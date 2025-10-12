locals {
  ami_id = var.aws_ami_id != "" ? var.aws_ami_id : data.aws_ami.amazon.id
}

data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.aws_instance_type
  subnet_id                   = var.aws_subnet_id
#   associate_public_ip_address = true
  security_groups             = ["default"] # TODO: make it configurable
  iam_instance_profile        = var.aws_instance_profile # TODO: use default role if no value provided
  key_name                    = var.aws_key_name

  tags = {
    Name = var.name
  }
}