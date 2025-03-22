resource "aws_security_group" "rds_sg" {
  count = local.sg_exists ? 0 : 1
  
  vpc_id = local.vpc_id_to_use

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

locals {
  sg_id_to_use = local.sg_exists ? local.sg_id : (length(aws_security_group.rds_sg) > 0 ? aws_security_group.rds_sg[0].id : null)
}
