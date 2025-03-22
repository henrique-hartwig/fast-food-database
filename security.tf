resource "aws_security_group" "rds_sg" {
  count = length(data.aws_security_group.rds) > 0 ? 0 : 1
  
  vpc_id = length(data.aws_vpc.existing) > 0 ? data.aws_vpc.existing.id : aws_vpc.main[0].id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-security-group"
  }
}
