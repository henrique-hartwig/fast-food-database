resource "aws_vpc" "main" {
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

locals {
  vpc_id_to_use = aws_vpc.main.id
}

resource "aws_subnet" "private_subnet" {
  count = 2

  vpc_id                  = local.vpc_id_to_use
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

resource "aws_subnet" "public_subnet" {
  count = 2

  vpc_id                  = local.vpc_id_to_use
  cidr_block              = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

data "aws_internet_gateway" "existing" {
  count = local.vpc_exists ? 1 : 0

  filter {
    name   = "attachment.vpc-id"
    values = [local.vpc_id]
  }
}

locals {
  igw_exists = local.vpc_exists && length(data.aws_internet_gateway.existing) > 0
}

resource "aws_internet_gateway" "gw" {
  vpc_id = local.vpc_id_to_use

  tags = {
    Name = "${var.project_name}-gateway"
  }
}

data "aws_route_tables" "existing" {
  count = local.vpc_exists ? 1 : 0

  vpc_id = local.vpc_id

  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-private-route-table"]
  }
}

locals {
  route_table_exists = local.vpc_exists && length(data.aws_route_tables.existing) > 0 && length(data.aws_route_tables.existing[0].ids) > 0
}

resource "aws_route_table" "private" {
  vpc_id = local.vpc_id_to_use

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id_to_use

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Criar um Elastic IP para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}
