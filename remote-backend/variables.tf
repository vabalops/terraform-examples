variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "bucket_name_prefix" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "enable_replication" {
  description = "Enable S3 replication resources"
  type        = bool
  default     = false
}

variable "aws_backup_region" {
  description = "The AWS region to deploy the backup S3 bucket in"
  type        = string
  default     = "eu-west-1"
}