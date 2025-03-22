resource "aws_db_instance" "postgres" {
  count = length(data.aws_db_instance.existing) > 0 ? 0 : 1
  
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
  vpc_security_group_ids = [length(data.aws_security_group.rds) > 0 ? data.aws_security_group.rds.id : aws_security_group.rds_sg[0].id]
  db_subnet_group_name   = length(data.aws_db_subnet_group.existing) > 0 ? data.aws_db_subnet_group.existing.name : aws_db_subnet_group.rds_subnet_group[0].name
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
  count = length(data.aws_db_subnet_group.existing) > 0 ? 0 : 1
  
  name_prefix = "${var.project_name}-rds-subnet-"
  subnet_ids  = length(data.aws_subnets.private.ids) > 0 ? data.aws_subnets.private.ids : aws_subnet.private_subnet[*].id

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}
