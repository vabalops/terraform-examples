data "aws_iam_policy_document" "assume_role" {
  count = var.enable_replication ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "replication" {
  count = var.enable_replication ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${aws_s3_bucket.replication[0].arn}/*"]
  }
}

resource "aws_iam_role" "replication" {
  count = var.enable_replication ? 1 : 0

  name               = "terraform-state-replication-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

resource "aws_iam_policy" "replication" {
  count = var.enable_replication ? 1 : 0

  name   = "terraform-state-replication-policy"
  policy = data.aws_iam_policy_document.replication[0].json
}

resource "aws_iam_role_policy_attachment" "replication" {
  count = var.enable_replication ? 1 : 0

  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}

resource "aws_s3_bucket" "replication" {
  count = var.enable_replication ? 1 : 0

  region        = var.aws_backup_region
  bucket        = "${aws_s3_bucket.terraform_state.bucket}-replica"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "replication" {
  count = var.enable_replication ? 1 : 0

  region = var.aws_backup_region
  bucket = aws_s3_bucket.replication[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.enable_replication ? 1 : 0

  depends_on = [aws_s3_bucket_versioning.replication]
  role       = aws_iam_role.replication[0].arn
  bucket     = aws_s3_bucket.terraform_state.id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replication[0].arn
      storage_class = "STANDARD"
    }
  }
}