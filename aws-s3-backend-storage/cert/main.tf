/*
Main Terraform template that builds an S3 bucket and stores a Terraform remote backend file.

Author: Chad Bartel
Date:   2021-05-28
*/

# Terraform configuration block
terraform {
  # Terraform provider requirement
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  # Terraform version requirement
  required_version = ">=0.15.4"
}


# Local variables
locals {
  # Backend
  region               = var.region != "" ? var.region : "us-west-2"
  profile              = var.profile != "" ? var.profile : null
  session_name         = var.session_name != "" ? var.session_name : "terraform"
  backend_bucket       = var.backend_bucket != "" ? var.backend_bucket : "${var.environment}-${local.region}-my-terraform-state-files"
  backend_key          = var.key != "" ? var.key : "${local.project}/terraform.tfstate"
  kms_key_id           = var.kms_key_id != "" ? var.kms_key_id : null
  workspace_key_prefix = var.workspace_key_prefix != "" ? var.workspace_key_prefix : "${var.environment}:"
  dynamodb_table       = var.dynamodb_table != "" ? var.dynamodb_table : null

  # AWS
  bucket  = var.bucket != "" ? var.bucket : "${var.environment}-${local.region}-my-terraform-backend-files"
  key     = var.key != "" ? var.key : "my-configuration"
  project = var.project != "" ? var.project : "aws-s3-backend-storage"
  tags = {
    Terraform = true
    env       = var.environment
    workspace = terraform.workspace
    project   = local.project
  }
}


# AWS provider
provider "aws" {
  region  = local.region
  profile = local.profile

  default_tags {
    tags = merge(
      var.default_tags,
      local.tags
    )
  }
}


# Create KMS key
resource "aws_kms_key" "key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10

  lifecycle {
    create_before_destroy = true
  }
}

# Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# S3 bucket ownership
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# S3 public access
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Create bucket object
resource "aws_s3_bucket_object" "examplebucket_object" {
  key        = "${local.key}/backend.tf"
  bucket     = aws_s3_bucket.bucket.id
  content    = data.template_file.backend.rendered
  kms_key_id = aws_kms_key.key.arn

  lifecycle {
    create_before_destroy = true
  }
}