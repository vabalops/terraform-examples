locals {
  availability_zones = data.aws_availability_zones.available.names
  vpc_prefix         = tonumber(split("/", var.aws_vpc_cidr)[1])
  additional_bits    = var.subnet_prefix_length - local.vpc_prefix
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.aws_vpc_cidr, local.additional_bits, count.index + 1)
  availability_zone       = element(local.availability_zones, count.index % length(local.availability_zones))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.aws_vpc_cidr, local.additional_bits, count.index + 10)
  availability_zone       = element(local.availability_zones, count.index % length(local.availability_zones))
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = "${var.name_prefix}-default-rt"
  }
}
