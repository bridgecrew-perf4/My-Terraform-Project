/*
Main Terraform template that builds the infrastructure defined in the modules.

Author: Chad Bartel
Date:   2021-05-14
*/

# Declare required Terraform providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

# Local variables
locals {
  tags = {
    Terraform = true
    env       = var.environment
    workspace = terraform.workspace
    project   = var.project_name
  }
}

# Create AWS Terraform provider
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = merge(
      var.default_tags,
      local.tags
    )
  }
}

# Execute DynamoDB module
module "dynamo" {
  source      = "./modules/dynamo"
  environment = var.environment
}

# Execute S3 module
module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  region      = var.region
  s3_bucket   = var.s3_bucket
  bucket_key  = var.bucket_key
}

# Execute IAM module
module "iam" {
  source         = "./modules/iam"
  environment    = var.environment
  s3_bucket      = module.s3.bucket_id
  kms_key        = module.s3.kms_key_id
  dynamodb_table = module.dynamo.dynamodb_table
}