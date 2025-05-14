//Adds outputs to root module
output "elasticache_replication_group_id" {
  value       = try(aws_elasticache_replication_group.redis[0].id, "")
  description = "The ID of the ElastiCache Replication Group."
}

output "elasticache_replication_group_primary_endpoint_address" {
  value       = try(aws_elasticache_replication_group.redis[0].primary_endpoint_address, "")
  description = "The address of the endpoint for the primary node in the replication group."
}

output "elasticache_replication_group_reader_endpoint_address" {
  value       = try(aws_elasticache_replication_group.redis[0].reader_endpoint_address, "")
  description = "The address of the endpoint for the primary node in the replication group."
}

output "elasticache_replication_group_member_clusters" {
  value       = try(aws_elasticache_replication_group.redis[0].member_clusters, "")
  description = "The identifiers of all the nodes that are part of this replication group."
}

output "elasticache_parameter_group_id" {
  value       = try(aws_elasticache_parameter_group.redis[0].id, "")
  description = "The ElastiCache parameter group name."
}

output "elasticache_auth_token" {
  description = "The Redis Auth Token."
  value       = try(aws_elasticache_replication_group.redis[0].auth_token, "")
}

output "elasticache_port" {
  description = "The Redis port."
  value       = try(aws_elasticache_replication_group.redis[0].port, "")
}

output "memcached_cluster_address" {
  description = "Memcached Cluster Address"
  value       = try(aws_elasticache_cluster.memcached[0].cluster_address, "")
}

output "memcached_cache_nodes" {
  description = "Memcached Node Details"
  value       = try(aws_elasticache_cluster.memcached[0].cache_nodes, "")
}