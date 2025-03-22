# Verifica se a VPC existe
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
  
  # Evita erro se não encontrar a VPC
  default_tags {
    tags = {}
  }
}

# Verifica se as subnets existem
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-private-subnet-*"]
  }
  
  depends_on = [data.aws_vpc.existing]
}

# Verifica se o security group existe
data "aws_security_group" "rds" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-rds-security-group"]
  }
  
  depends_on = [data.aws_vpc.existing]
}

# Verifica se o DB subnet group existe
data "aws_db_subnet_group" "existing" {
  name = "${var.project_name}-rds-subnet-group"
}

# Verifica se a instância RDS existe
data "aws_db_instance" "existing" {
  db_instance_identifier = "${var.project_name}-db"
} 