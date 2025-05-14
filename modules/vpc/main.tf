
# Get Data on the number of AZ in the requested region
data "aws_availability_zones" "available" {}

# Find the number of AZ's to be used based on HA factor
locals {
  count_az = length(data.aws_availability_zones.available.names) > var.high_availabilty_factor ? var.high_availabilty_factor : length(data.aws_availability_zones.available.names)
}

# The number of private subnets is equal to the (AZ's in the region*2). Can be increased if more private subnets are required.
# The original design called for single private subnet but SQL quickstart guides require static IPs and there is no option to 
# exclude IPs from DHCP scope

locals {
  max_subnet_length =  (var.enable_db_subnet) ? (local.count_az * 2) : local.count_az

}

######
# VPC
######
resource "aws_vpc" "template" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  # enable_classiclink   = "false"
  tags = merge(
    {
      "Name" = format("%s-VPC", lower(var.vpc_name))
    },
    var.tags,
    var.vpc_tags,
  )
}

# Public and Private Subnets - 1 public and 2 private subnet per AZ 

################
# Public subnet
################
resource "aws_subnet" "public-subnets" {
  vpc_id            = aws_vpc.template.id
  count             = local.count_az
  cidr_block        = cidrsubnet(aws_vpc.template.cidr_block, 4, (count.index))
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    {
      "Name" = format("%s-public_subnet-%s", var.vpc_name,data.aws_availability_zones.available.names[count.index])
    },
    var.tags,
    var.public_subnet_tags,
  )
}

resource "aws_ssm_parameter" "public-subnets" {
  count = local.count_az
  name  = "/${var.vpc_name}/public_subnets/${count.index}"
  type  = "String"
  value = element(aws_subnet.public-subnets.*.id, count.index)
}

#################
# Private subnet
#################
resource "aws_subnet" "private-subnets" {
  vpc_id            = aws_vpc.template.id
  count             = local.count_az
  cidr_block        = cidrsubnet(aws_vpc.template.cidr_block, 4, (local.count_az + count.index))
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    {
      "Name" = format("%s-private_subnet-%s", var.vpc_name,data.aws_availability_zones.available.names[count.index])
    },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_ssm_parameter" "private-subnets" {
  count = local.count_az
  name  = "/${var.vpc_name}/private_subnets/${count.index}"
  type  = "String"
  value = element(aws_subnet.private-subnets.*.id, count.index)
}

#################
# Database subnet
#################
resource "aws_subnet" "db-subnets" {
  vpc_id            = aws_vpc.template.id
  count             = var.enable_db_subnet ? (2*local.count_az) : 0
  cidr_block        = cidrsubnet(aws_vpc.template.cidr_block, 4, (local.max_subnet_length + count.index))
  availability_zone = data.aws_availability_zones.available.names[count.index%local.count_az]
  tags = merge(
    {
      "Name" = format("%s-db_subnet-%s", var.vpc_name,data.aws_availability_zones.available.names[count.index%local.count_az])
    },
    var.tags,
    var.db_subnet_tags,
  )
}

resource "aws_ssm_parameter" "db-subnets" {
  count = var.enable_db_subnet ? (2*local.count_az) : 0
  name  = "/${var.vpc_name}/db_subnets/${count.index}"
  type  = "String"
  value = element(aws_subnet.db-subnets.*.id, count.index)
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "template" {
  count = local.count_az > 0 ? 1 : 0
  vpc_id = aws_vpc.template.id
  tags = merge(
    {
      "Name" = format("%s-IGW", var.vpc_name)
    },
    var.tags,
  )
}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  count = local.count_az > 0 ? 1 : 0
  vpc_id = aws_vpc.template.id
  tags = merge(
    {
      "Name" = format("%s-RT-public", var.vpc_name)
    },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count = local.count_az > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.template[0].id
}

#################
# Private routes
# There are so many routing tables as the largest amount of subnets of each type (really?)
#################
resource "aws_route_table" "private" {
  count = local.count_az > 0 ? local.count_az : 0
  vpc_id = aws_vpc.template.id
  tags = merge(
    {
      "Name" = format("%s-RT-private-%s", var.vpc_name, data.aws_availability_zones.available.names[count.index])
    },
    var.tags,
    var.private_route_table_tags,
  )

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }
}

##############
# NAT Gateway
##############
# Workaround for interpolation not being able to "short-circuit" the evaluation of the conditional branch that doesn't end up being used
# Source: https://github.com/hashicorp/terraform/issues/11566#issuecomment-289417805
#
# The logical expression would be
#
#    nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat.*.id
#
# but then when count of aws_eip.nat.*.id is zero, template would throw a resource not found error on aws_eip.nat.*.id.
# The two joins are evaluated (e.g after join var.external_nat_ip_ids =<blank> and aws_eip.nat.*.id = 1.1.1.1,2.2.2.2,3.3.3.3) and the conditional selects on 
# var.reuse_nat_ips which by default is set to False and thus it selects aws_eip.nat.*.id and the list is then split again to indiviual Ips. Complicated UH :(

locals {
  nat_gateway_ips = split(",", (var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id)))
}

resource "aws_eip" "nat" {
  count =  (var.enable_nat_gateway && !var.reuse_nat_ips) ? (var.single_nat_gateway ? 1 : local.count_az) : 0

  vpc = true
  tags = merge(
    {
      "Name" = format("%s-EIP-%s", var.vpc_name, element(data.aws_availability_zones.available.names, (var.single_nat_gateway ? 0 : count.index)))
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "template" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.count_az) : 0

  allocation_id = element(local.nat_gateway_ips, (var.single_nat_gateway ? 0 : count.index))
  subnet_id     = element(aws_subnet.public-subnets.*.id, (var.single_nat_gateway ? 0 : count.index))
  tags = merge(
    {
      "Name" = format("%s-NGW-%s", var.vpc_name, element(data.aws_availability_zones.available.names, (var.single_nat_gateway ? 0 : count.index)))
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.template]
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? local.count_az : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.template.*.id, count.index)
  
  timeouts {
    create = "5m"
  }
}

###################################################################################################
# Route table association. There is only 1 public RT but there are N private RT, where N = # of AZ
####################################################################################################
resource "aws_route_table_association" "private" {
  count = local.count_az > 0 ? local.count_az : 0

  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "private-db" {
  count = local.count_az > 0 ? (2*local.count_az) : 0

  subnet_id      = element(aws_subnet.db-subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count = var.enable_db_subnet && (local.count_az > 0) ? local.count_az : 0

  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

######################
# VPC Endpoint for S3
######################
data "aws_vpc_endpoint_service" "s3" {
  count   = var.enable_s3_endpoint ? 1 : 0
  service = "s3"

  # Used for backwards compatability where `service_type` is not yet available in the provider used
  filter {
    name   = "service-type"
    values = [var.s3_endpoint_type]
  }
}

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.template.id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public[0].id
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = var.enable_s3_endpoint ? local.count_az : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

resource "aws_ssm_parameter" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0
  name  = "/${var.vpc_name}/endpoint/s3"
  type  = "String"
  value = aws_vpc_endpoint.s3[0].prefix_list_id
}

#####################################################
# Security group for SSM endpoint
#####################################################

resource "aws_security_group" "secgroup_ssm_endpoint" {
  count  = var.enable_ssm_endpoint ? 1 : 0
  name   = "${var.vpc_name}_ssm_endpoint_SG"
  vpc_id = aws_vpc.template.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      "Name" = format("%s_ssm_endpoint_SG", var.vpc_name)
    },
    var.tags,
    var.sec_group_tags,
  )
}

######################
# VPC Endpoint for SSM
######################
data "aws_vpc_endpoint_service" "ssm" {
  count   = var.enable_ssm_endpoint ? 1 : 0
  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm" {
  count = var.enable_ssm_endpoint ? 1 : 0

  vpc_id             = aws_vpc.template.id
  service_name       = data.aws_vpc_endpoint_service.ssm[0].service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.secgroup_ssm_endpoint[0].id]
  subnet_ids         = coalescelist(aws_subnet.private-subnets.*.id)
}

#####################################################
# Security group for EC2-messages endpoint
#####################################################

resource "aws_security_group" "secgroup_ec2messages_endpoint" {
  count  = var.enable_ec2messages_endpoint ? 1 : 0
  name   = "${var.vpc_name}_ec2messages_endpoint_SG"
  vpc_id = aws_vpc.template.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    {
      "Name" = format("%s_ec2messages_endpoint_SG", var.vpc_name)
    },
    var.tags,
    var.sec_group_tags,
  )
}

################################
# VPC Endpoint for EC2 Messages
################################

data "aws_vpc_endpoint_service" "ec2messages" {
  count   = var.enable_ec2messages_endpoint ? 1 : 0
  service = "ec2messages"
}

resource "aws_vpc_endpoint" "ec2messages" {
  count = var.enable_ec2messages_endpoint ? 1 : 0

  vpc_id             = aws_vpc.template.id
  service_name       = data.aws_vpc_endpoint_service.ec2messages[0].service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.secgroup_ec2messages_endpoint[0].id]
  subnet_ids         = coalescelist(aws_subnet.private-subnets.*.id)
}
