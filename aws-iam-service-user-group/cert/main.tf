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


# Create IAM policy for each additonal action key-list
resource "aws_iam_policy" "policy" {
  for_each = var.custom_iam_policy_actions

  name = format(
    "%s_service_group_policy_%s",
    each.key,
    var.environment
  )
  path        = "/"
  description = "Service user group IAM policy for ${each.key}"

  policy = data.aws_iam_policy_document.this[each.key].json

  lifecycle {
    create_before_destroy = true
  }
}

# Create IAM user group with policies
resource "aws_iam_group" "service" {
  name = format(
    "serviceusergroup%s",
    var.environment != "prod" ? "-${var.environment}" : ""
  )
  path = "/"

  lifecycle {
    create_before_destroy = true
  }
}

# Attach IAM polcies to user group
resource "aws_iam_group_policy_attachment" "attach_policies" {
  count = length(var.iam_policies)

  group = aws_iam_group.service.name
  policy_arn = element(
    var.iam_policies,
    count.index
  )
}
resource "aws_iam_group_policy_attachment" "attach_custom" {
  for_each = var.custom_iam_policy_actions

  group      = aws_iam_group.service.name
  policy_arn = aws_iam_policy.policy[each.key].arn
}