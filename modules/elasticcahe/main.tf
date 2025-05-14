resource "aws_elasticache_replication_group" "redis" {
  count                       = var.engine == "redis" ? 1 : 0
  engine                      = var.engine
  parameter_group_name        = aws_elasticache_parameter_group.redis[count.index].name
  subnet_group_name           = aws_elasticache_subnet_group.redis[count.index].name
  security_group_ids          = var.security_group_ids
  multi_az_enabled            = var.multi_az_enabled
  preferred_cache_cluster_azs = var.availability_zones
  replication_group_id        = var.name_prefix
  num_cache_clusters          = var.cluster_mode_enabled ? null : var.number_cache_clusters
  node_type                   = var.node_type
  port                        = var.port
  maintenance_window          = var.maintenance_window
  snapshot_window             = var.snapshot_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  automatic_failover_enabled  = var.automatic_failover_enabled && var.number_cache_clusters > 1 ? true : false
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  transit_encryption_enabled  = var.transit_encryption_enabled
  auth_token                  = var.auth_token != "" ? var.auth_token : null
  kms_key_id                  = var.kms_key_id
  apply_immediately           = var.apply_immediately
  description                 = var.description
  notification_topic_arn      = var.notification_topic_arn
  num_node_groups             = var.cluster_mode_enabled ? var.num_node_groups : null
  replicas_per_node_group     = var.cluster_mode_enabled ? var.replicas_per_node_group : null

  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.tags,
  )
}

resource "random_id" "redis_pg" {
  count       = var.engine == "redis" ? 1 : 0
  byte_length = 2

  keepers = {
    family = var.redis_family
  }
}

resource "aws_elasticache_parameter_group" "redis" {
  count       = var.engine == "redis" ? 1 : 0
  name        = var.name_prefix
  family      = var.redis_family
  description = var.description

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  count       = var.engine == "redis" ? 1 : 0
  name        = var.name_prefix
  subnet_ids  = var.subnet_ids
  description = var.description
}

resource "aws_elasticache_cluster" "memcached" {
  count                  = var.engine == "memcached" ? 1 : 0
  cluster_id             = var.name_prefix
  engine                 = var.engine
  port                   = var.port
  num_cache_nodes        = var.number_cache_clusters
  az_mode                = var.az_mode
  parameter_group_name   = aws_elasticache_parameter_group.memcached[count.index].name
  node_type              = var.node_type
  subnet_group_name      = aws_elasticache_subnet_group.memcached[count.index].name
  security_group_ids     = var.security_group_ids
  notification_topic_arn = var.notification_topic_arn
  maintenance_window     = var.maintenance_window

  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.tags,
  )
}

resource "aws_elasticache_subnet_group" "memcached" {
  count       = var.engine == "memcached" ? 1 : 0
  name        = var.name_prefix
  subnet_ids  = var.subnet_ids
  description = var.description
}

resource "aws_elasticache_parameter_group" "memcached" {
  count       = var.engine == "memcached" ? 1 : 0
  name        = var.name_prefix
  family      = var.memcached_family
  description = var.description

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
