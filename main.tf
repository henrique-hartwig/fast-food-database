resource "aws_db_instance" "postgres" {
  identifier             = "fastfood-db"
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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = {
    Name = "fastfood-db"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "fastfood-rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id

  tags = {
    Name = "fastfood-rds-subnet-group"
  }
}
