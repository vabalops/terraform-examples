variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "name_prefix" {
  description = "The name prefix for each resource."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets to create in a region. Each subnet will be created in a different availability zone."
  type    = number
}

variable "subnet_prefix_length" {
  description = "Size of each subnet in bits. For example, a value of 24 will create subnets with a CIDR block of /24."
  type    = number
}