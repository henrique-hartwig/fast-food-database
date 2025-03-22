resource "aws_db_instance" "postgres" {
  count = local.db_exists ? 0 : 1
  
  identifier             = "${var.project_name}-db"
  allocated_storage      = var.db_storage
  storage_type           = "gp2"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  multi_az               = var.db_multi_az
  vpc_security_group_ids = [local.sg_id_to_use]
  db_subnet_group_name   = local.subnet_group_name_to_use
  publicly_accessible    = false
  skip_final_snapshot    = true

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      identifier,
      engine,
      engine_version,
      username,
      password,
      allocated_storage,
      instance_class,
      db_name,
      vpc_security_group_ids,
      db_subnet_group_name
    ]
  }

  tags = {
    Name = "${var.project_name}-db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  count = local.subnet_group_exists ? 0 : 1
  
  name_prefix = "${var.project_name}-rds-subnet-"
  subnet_ids  = length(local.subnet_ids) > 0 ? local.subnet_ids : aws_subnet.private_subnet[*].id

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}

locals {
  subnet_group_name_to_use = local.subnet_group_exists ? "${var.project_name}-rds-subnet-group" : (length(aws_db_subnet_group.rds_subnet_group) > 0 ? aws_db_subnet_group.rds_subnet_group[0].name : null)
}
