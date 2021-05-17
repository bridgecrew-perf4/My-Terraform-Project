/*
Main Terraform template that builds the infrastructure defined in the modules.

Author: Chad Bartel
Date:   2021-05-15
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

  # Use conditional expression to load variables (condition ? true_val : false_val)
  azs             = var.azs != null ? var.azs : ["${var.region}a", "${var.region}b"]
  cidr            = var.cidr != null ? var.cidr : "10.0.0.0/16"
  public_subnets  = var.public_subnets != null ? var.public_subnets : ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = var.private_subnets != null ? var.private_subnets : ["10.0.1.0/24", "10.0.2.0/24"]
}

# Declare Terraform backend
terraform {
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "prod-us-west-2-terraform-state-20210515"
    key                  = "aws-simple-bastion-with-vpc/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "8c97e9b0-7491-47fe-83d2-878db0064d20"
    workspace_key_prefix = "prod:"

    # DynamoDB lock table
    dynamodb_table = "prod-tf-remote-state-lock"
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

# Execute VPC module
module "vpc" {
  source          = "./modules/vpc"
  environment     = var.environment
  azs             = local.azs
  cidr            = local.cidr
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}