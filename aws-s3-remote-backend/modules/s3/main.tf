/*
Terraform template that builds S3 resources.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
  bucket = format(
    "%s-%s-%s-%s",
    var.environment,
    var.region,
    var.s3_bucket,
    formatdate(
      "YYYY-MM-DD",
      timestamp()
    )
  )
}

# State bucket key
resource "aws_kms_key" "this" {
  deletion_window_in_days = 30
  enable_key_rotation     = true
  description             = "The key used to encrypt the remote state bucket"

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# State bucket
resource "aws_s3_bucket" "state" {
  bucket = local.bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.arn
      }
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# State bucket policy
resource "aws_s3_bucket_policy" "state_force_ssl" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.s3_document.json

  lifecycle {
    create_before_destroy = true
  }
}

# State public access block
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_policy.state_force_ssl
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# State bucket folder object
resource "aws_s3_bucket_object" "bucket_key" {
  bucket = aws_s3_bucket.state.id
  key    = var.bucket_key

  lifecycle {
    create_before_destroy = true
  }
}