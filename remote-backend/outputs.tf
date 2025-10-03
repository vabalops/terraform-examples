output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_region" {
  description = "The region the S3 bucket is created in"
  value       = aws_s3_bucket.terraform_state.region
}