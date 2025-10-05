variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/20" # 10.0.0.0 - 10.0.15.255
}

variable "aws_instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t3.micro"
}