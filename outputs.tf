output "db_endpoint" {
  value = local.db_exists ? data.aws_db_instance.existing[0].endpoint : (length(aws_db_instance.postgres) > 0 ? aws_db_instance.postgres[0].endpoint : null)
}

output "db_port" {
  value = local.db_exists ? data.aws_db_instance.existing[0].port : (length(aws_db_instance.postgres) > 0 ? aws_db_instance.postgres[0].port : null)
}

output "rds_security_group_id" {
  value = local.sg_id_to_use
}

output "vpc_id" {
  value = local.vpc_id_to_use
}