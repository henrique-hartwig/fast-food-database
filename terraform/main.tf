resource "aws_dynamodb_table" "users" {
  name           = "${var.project_name}-users-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "cpf"
  
  attribute {
    name = "cpf"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
