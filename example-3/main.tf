module "vpc_1" {
  source = "../modules/vpc"

  aws_vpc_cidr         = "10.0.0.0/20"
  name_prefix          = "example-3-1"
  aws_region           = var.aws_region
  subnet_count         = 2
  subnet_prefix_length = 24
}

module "vpc_2" {
  source = "../modules/vpc"

  aws_vpc_cidr         = "10.0.16.0/20"
  name_prefix          = "example-3-2"
  aws_region           = var.aws_region
  subnet_count         = 2
  subnet_prefix_length = 24
}

module "vpc_3" {
  source = "../modules/vpc"

  aws_vpc_cidr         = "10.0.32.0/20"
  name_prefix          = "example-3-3"
  aws_region           = var.aws_region
  subnet_count         = 2
  subnet_prefix_length = 24
}

resource "aws_iam_role" "ssm" {
  name = "ec2-ssm-role"
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
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ssm.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# WIP
module "ec2_1" {
  source = "../modules/ec2"

  name                 = "ec2-1"
  aws_instance_type    = var.aws_instance_type
  aws_subnet_id        = module.vpc_1.public_subnets[0]
  aws_instance_profile = aws_iam_instance_profile.ssm.name
  aws_key_name         = var.aws_key_name
}