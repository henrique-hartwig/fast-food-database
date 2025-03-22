output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}