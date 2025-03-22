data "aws_vpcs" "all" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
}

locals {
  vpc_exists = length(data.aws_vpcs.all.ids) > 0
  vpc_id = local.vpc_exists ? tolist(data.aws_vpcs.all.ids)[0] : ""
}

data "aws_vpc" "existing" {
  count = local.vpc_exists ? 1 : 0
  id    = local.vpc_id
}

data "aws_subnets" "private" {
  count = local.vpc_exists ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-private-subnet-*"]
  }
}

data "aws_security_groups" "rds" {
  count = local.vpc_exists ? 1 : 0
  
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-rds-security-group"]
  }
}

locals {
  sg_exists = local.vpc_exists && length(data.aws_security_groups.rds) > 0 && length(data.aws_security_groups.rds[0].ids) > 0
  sg_id = local.sg_exists ? tolist(data.aws_security_groups.rds[0].ids)[0] : ""
}

data "aws_security_group" "rds" {
  count = local.sg_exists ? 1 : 0
  id    = local.sg_id
}

# Verifica se o DB subnet group existe
data "aws_db_subnet_groups" "all" {
  filter {
    name   = "db-subnet-group-name"
    values = ["${var.project_name}-rds-subnet-group"]
  }
}

locals {
  subnet_group_exists = length(data.aws_db_subnet_groups.all.names) > 0
}

# Verifica se a instância RDS existe
data "aws_db_instances" "all" {
  filter {
    name   = "db-instance-id"
    values = ["${var.project_name}-db"]
  }
}

locals {
  db_exists = length(data.aws_db_instances.all.instance_identifiers) > 0
}

data "aws_db_instance" "existing" {
  count                  = local.db_exists ? 1 : 0
  db_instance_identifier = "${var.project_name}-db"
} 