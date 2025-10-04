resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "terraform_state" {
  region = var.aws_region
  bucket = "${var.bucket_name_prefix}-${random_id.bucket_id.hex}"

  # ! Deprecated
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "keep-last-5-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days           = 1
      newer_noncurrent_versions = 5
    }
  }
}
