##########
# Provider
##########

variable "high_availabilty_factor" {
  description = "Defines the number of AZ's to be used in a region. DEfault is 3 or less AZ's per region"
  type        = number
  default     = 3
}

######
# VPC
######
variable "cidr_block" {
  description = "Enter a /16 IP space for this VPC. E.g.  10.50.0.0/16"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "vpc_name" {
  description = "Enter a VPC name for this VPC."
  type        = string
}

################
# Public subnet
################
variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

################
# Private subnet
################
variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

##############
# DB subnet
##############
variable "enable_db_subnet" {
  description = "Should be true if you want to provision a seperate Database subnet"
  type        = bool
  default     = true
}

################
# Private subnet
################
variable "db_subnet_tags" {
  description = "Additional tags for the db subnets"
  type        = map(string)
  default     = {}
}

################
# Publiс routes
################
variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

#################
# Private routes
#################
variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

##############
# NAT Gateway
##############
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

##############
# S3 Endpoint
##############

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = true
}

variable "sec_group_tags" {
  description = "Additional tags for the Security Group"
  type        = map(string)
  default     = {}
}

variable "s3_endpoint_type" {
  description = "S3 VPC endpoint type. Note - S3 Interface type support is only available on AWS provider 3.10 and later"
  type        = string
  default     = "Gateway"
}

##############
# SSM Endpoint
##############

variable "enable_ssm_endpoint" {
  description = "Should be true if you want to provision an SSM endpoint to the VPC"
  type        = bool
  default     = true
}

######################
# ec2messages Endpoint
######################

variable "enable_ec2messages_endpoint" {
  description = "Should be true if you want to provision an SSM endpoint to the VPC"
  type        = bool
  default     = true
}
