/*
Data used by the IAM Terraform module.
*/

# S3 bucket data
data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket
}

# KMS key data
data "aws_kms_key" "selected" {
  key_id = var.kms_key
}

# DynamoDB lock table
data "aws_dynamodb_table" "selected" {
  name = var.dynamodb_table
}

# Terraform IAM policy document to assume any role if it's run by any service
data "aws_iam_policy_document" "terraform_assume" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
        "eks.amazonaws.com",
        "lambda.amazonaws.com",
        "ebs.amazonaws.com",
        "batch.amazonaws.com"
      ]
    }
  }
}

# Terraform IAM policy document to manage state remotely
data "aws_iam_policy_document" "terraform_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      data.aws_s3_bucket.selected.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl"
    ]
    resources = [
      data.aws_s3_bucket.selected.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      data.aws_dynamodb_table.selected.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    resources = [
      data.aws_kms_key.selected.arn
    ]
  }
}