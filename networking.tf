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
