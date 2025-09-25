variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"

}
variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "terraform-state"

}