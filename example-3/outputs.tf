output "vpc_1_subnets" {
  value = {
    public  = module.vpc_1.public_subnet_cidrs
    private = module.vpc_1.private_subnet_cidrs
  }
}

output "vpc_2_subnets" {
  value = {
    public  = module.vpc_2.public_subnet_cidrs
    private = module.vpc_2.private_subnet_cidrs
  }
}

output "vpc_3_subnets" {
  value = {
    public  = module.vpc_3.public_subnet_cidrs
    private = module.vpc_3.private_subnet_cidrs
  }
}