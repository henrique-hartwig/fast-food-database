output "dynamodb_users_table_name" {
  value       = aws_dynamodb_table.users.name
  description = "Name of the users table in DynamoDB"
}
