variable "aws_ami_id" {
    description = "The AMI ID to use for the EC2 instance"
    type        = string
    default     = ""
}

variable "aws_instance_type" {
    description = "The instance type to use for the EC2 instance"
    type        = string
    default     = "t3.micro"
}

variable "name" {
    description = "The name to use for the EC2 instance"
    type        = string
    default     = ""
}

variable "aws_subnet_id" {
    description = "The subnet ID to use for the EC2 instance"
    type        = string
}

variable "aws_instance_profile" {
    description = "The instance profile to use for the EC2 instance"
    type        = string
}

variable "aws_key_name" {
    description = "The key name to use for the EC2 instance"
    type        = string
    default     = ""
}