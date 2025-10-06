data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_vpc" "example_2" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name = "example-2-vpc"
  }
}

resource "aws_internet_gateway" "example_2" {
  vpc_id = aws_vpc.example_2.id

  tags = {
    Name = "example-2-igw"
  }
}

resource "aws_subnet" "example_2" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.example_2.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "example-2-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_internet_access" {
  vpc_id = aws_vpc.example_2.id

  tags = {
    Name = "example-2-pub-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_internet_access.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_2.id
}

resource "aws_route_table_association" "public_internet_access" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.example_2[count.index].id
  route_table_id = aws_route_table.public_internet_access.id
}

resource "aws_security_group" "server" {
  name        = "example-2-ec2-sg"
  description = "Default security group"
  vpc_id      = aws_vpc.example_2.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-2-ec2-sg"
  }
}

resource "aws_instance" "example_2" {
  count = length(var.availability_zones)

  ami                         = data.aws_ami.amazon.id
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.example_2[count.index].id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.server.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm.name
  key_name                    = "awsec2"

  tags = {
    Name = "example-2-instance-${count.index + 1}"
  }
}

resource "aws_iam_role" "ssm" {
  name = "example-2-ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm" {
  name = "example-2-instance-profile"
  role = aws_iam_role.ssm.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
