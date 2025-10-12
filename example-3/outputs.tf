output "vpc_1_subnets" {
  value = {
    public  = module.vpc-1.public_subnet_cidrs
    private = module.vpc-1.private_subnet_cidrs
  }
}

output "vpc_2_subnets" {
  value = {
    public  = module.vpc-2.public_subnet_cidrs
    private = module.vpc-2.private_subnet_cidrs
  }
}

output "vpc_3_subnets" {
  value = {
    public  = module.vpc-3.public_subnet_cidrs
    private = module.vpc-3.private_subnet_cidrs
  }
}