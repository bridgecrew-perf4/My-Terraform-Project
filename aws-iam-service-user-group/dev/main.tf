/*
Terraform template that builds an IAM user group for services like Jenkins, Terraform, EC2, etc.

Author: Chad Bartel
Date:   2021-06-06
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


# TODO: Create IAM policy for each additonal action key-list
resource "aws_iam_policy" "name" {
  for_each = var.custom_iam_policy_actions
}

# TODO: Create IAM user group with policies
resource "aws_iam_group" "service" {
  
}