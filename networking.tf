# Cria a VPC apenas se não existir
resource "aws_vpc" "main" {
  count = length(data.aws_vpc.existing) > 0 ? 0 : 1
  
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags,
      cidr_block
    ]
  }

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Cria as subnets apenas se não existirem
resource "aws_subnet" "private_subnet" {
  count = length(data.aws_subnets.private.ids) > 0 ? 0 : 2
  
  vpc_id                  = length(data.aws_vpc.existing) > 0 ? data.aws_vpc.existing.id : aws_vpc.main[0].id
  cidr_block              = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = false

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags,
      cidr_block
    ]
  }

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  count = length(data.aws_vpc.existing) > 0 ? 0 : 1
  
  vpc_id = length(data.aws_vpc.existing) > 0 ? data.aws_vpc.existing.id : aws_vpc.main[0].id

  tags = {
    Name = "${var.project_name}-gateway"
  }
}

resource "aws_route_table" "private" {
  count = length(data.aws_vpc.existing) > 0 ? 0 : 1
  
  vpc_id = length(data.aws_vpc.existing) > 0 ? data.aws_vpc.existing.id : aws_vpc.main[0].id

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}
