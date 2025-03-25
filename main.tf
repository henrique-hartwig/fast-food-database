resource "aws_db_instance" "postgres" {
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
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = true
  skip_final_snapshot    = true

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      identifier,
      username,
      password,
      instance_class,
    ]
  }

  tags = {
    Name = "${var.project_name}-db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "${var.project_name}-rds-subnet-"
  subnet_ids  = concat(aws_subnet.private_subnet[*].id, aws_subnet.public_subnet[*].id)

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}
