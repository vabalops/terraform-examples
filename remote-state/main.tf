resource "random_id" "bucket_id" {
  byte_length = 8

}

resource "aws_s3_bucket" "terraform-state" {
  bucket = var.bucket_name + "-${random_id.bucket_id.hex}"


}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform-state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_lifecycle_configuration" "name" {
  bucket = aws_s3_bucket.terraform-state.id

  #WIP
}