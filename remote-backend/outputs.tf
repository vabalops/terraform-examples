output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "bucket_region" {
  description = "The region the S3 bucket is created in"
  value       = aws_s3_bucket.terraform_state.region
}

output "cross_region_replication_enabled" {
  description = "Is cross region replication enabled"
  value       = var.enable_replication
}

output "replication_bucket_name" {
  description = "The name of the replication S3 bucket"
  value       = var.enable_replication ? aws_s3_bucket.replication[0].bucket : null
}

output "replica_bucket_region" {
  description = "The region the S3 bucket is created in"
  value       = var.enable_replication ? aws_s3_bucket.replication[0].region : null
}