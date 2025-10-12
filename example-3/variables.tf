variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "aws_key_name" {
  description = "The key name to use for the EC2 instance"
  type        = string
  default     = "awsec2"
}

variable "aws_instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

