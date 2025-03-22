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
  db_exists = length(data.aws_db_instances.all.instance_identifiers) > 0
  subnet_group_exists = try(
    data.aws_db_subnet_group.existing[0].name != "",
    false
  )
}

data "aws_db_subnet_group" "existing" {
  count = 1
  name  = "${var.project_name}-rds-subnet-group"

}
