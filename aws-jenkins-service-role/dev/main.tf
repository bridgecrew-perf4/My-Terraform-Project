/*
Main Terraform template that builds a Jenkins service role.

Author: Chad Bartel
Date:   2021-05-27
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

  # Configure backend
  backend "s3" {
    # S3 state bucket
    region               = "us-west-2"
    profile              = "sso_poweruser"
    session_name         = "terraform"
    bucket               = "dev-us-west-2-terraform-state-20210515"
    key                  = "aws-jenkins-service-role/terraform.tfstate"
    encrypt              = true
    kms_key_id           = "2a77097c-c08b-457b-9866-f61570ea83c7"
    workspace_key_prefix = "dev:"

    # DynamoDB lock table
    dynamodb_table = "dev-tf-remote-state-lock"
  }

  # Terraform version requirement
  required_version = ">=0.15.4"
}


# Local variables
locals {
  project       = var.project != "" ? var.project : "aws-jenkins-service-role"
  profile       = var.profile != "" ? var.profile : "default"
  region        = var.region != "" ? var.region : "us-west-2"
  aws_account   = var.aws_account != "" ? var.aws_account : "000000000000"
  iam_role      = var.iam_role != "" ? var.iam_role : "jenkins-service-role-${var.environment}"
  principal_arn = var.principal_arn != "" ? var.principal_arn : "arn:aws:iam::${local.aws_account}:root"
  tags = {
    Terraform = true
    env       = var.environment
    workspace = terraform.workspace
    project   = local.project
  }
}


# AWS provider
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


# IAM role for Jenkins
resource "aws_iam_role" "jenkins_role" {
  name        = local.iam_role
  path        = "/"
  description = "AWS IAM role to be used by Jenkins to perform various orchestrated tasks"

  assume_role_policy = data.aws_iam_policy_document.assume.json

  lifecycle {
    create_before_destroy = true
  }
}

# IAM policy for Jenkins
resource "aws_iam_policy" "jenkins_policy" {
  name        = "jenkins-service-policy-${var.environment}"
  path        = "/"
  description = "AWS IAM role providing access to various services for Jenkins"

  policy = data.aws_iam_policy_document.services.json

  lifecycle {
    create_before_destroy = true
  }
}

# Attach IAM policy to role
resource "aws_iam_role_policy_attachment" "name" {
  role       = aws_iam_role.jenkins_role.id
  policy_arn = aws_iam_policy.jenkins_policy.arn

  lifecycle {
    create_before_destroy = true
  }
}