module "vpc-1" {
  source = "../modules/vpc"

  aws_vpc_cidr = "10.0.0.0/20"
  name_prefix  = "example-3-1"
  aws_region   = var.aws_region
  subnet_count           = 2
  subnet_prefix_length   = 24
}

module "vpc-2" {
  source = "../modules/vpc"

  aws_vpc_cidr = "10.0.16.0/20"
  name_prefix  = "example-3-2"
  aws_region   = var.aws_region
  subnet_count           = 2
  subnet_prefix_length   = 24
}

module "vpc-3" {
  source = "../modules/vpc"

  aws_vpc_cidr = "10.0.32.0/20"
  name_prefix  = "example-3-3"
  aws_region   = var.aws_region
  subnet_count           = 2
  subnet_prefix_length   = 24
}