output "db_endpoint" {
  value = length(data.aws_db_instance.existing) > 0 ? data.aws_db_instance.existing.endpoint : (length(aws_db_instance.postgres) > 0 ? aws_db_instance.postgres[0].endpoint : null)
}

output "db_port" {
  value = length(data.aws_db_instance.existing) > 0 ? data.aws_db_instance.existing.port : (length(aws_db_instance.postgres) > 0 ? aws_db_instance.postgres[0].port : null)
}

output "rds_security_group_id" {
  value = length(data.aws_security_group.rds) > 0 ? data.aws_security_group.rds.id : (length(aws_security_group.rds_sg) > 0 ? aws_security_group.rds_sg[0].id : null)
}

output "vpc_id" {
  value = length(data.aws_vpc.existing) > 0 ? data.aws_vpc.existing.id : (length(aws_vpc.main) > 0 ? aws_vpc.main[0].id : null)
}