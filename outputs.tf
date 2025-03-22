output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "rds_security_group_id" {
  value = local.sg_id_to_use
}

output "vpc_id" {
  value = aws_vpc.main.id
}