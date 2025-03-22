data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
}

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

data "aws_db_subnet_group" "existing" {
  name = "${var.project_name}-rds-subnet-group"
}

data "aws_db_instance" "existing" {
  db_instance_identifier = "${var.project_name}-db"
} 