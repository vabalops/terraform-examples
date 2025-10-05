data "aws_availability_zones" "available" {
  state = "available"

}

resource "aws_vpc" "example_1" {
  tags = {
    Name = "example-1-vpc"
  }
  cidr_block = var.aws_vpc_cidr
}

resource "aws_internet_gateway" "example_1" {
  vpc_id = aws_vpc.example_1.id

  tags = {
    Name = "example-1-igw"
  }
}

resource "aws_subnet" "example_1" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.example_1.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "example-1-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.example_1.id
  tags = {
    Name = "example-1-public-route-table"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_1.id
}

resource "aws_route_table_association" "public_internet_access" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.example_1[count.index].id
  route_table_id = aws_route_table.public_internet_access.id
}
