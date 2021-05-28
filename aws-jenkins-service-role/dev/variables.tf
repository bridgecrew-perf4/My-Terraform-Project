/*
Variables used with the main Terraform template.
*/

variable "project" {
  type        = string
  default     = ""
  description = "Name of Terraform project"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"
}

variable "profile" {
  type        = string
  default     = ""
  description = "AWS profile name"
}

variable "region" {
  type        = string
  default     = ""
  description = "AWS region"
}

variable "default_tags" {
  type        = map(any)
  default     = {}
  description = "Default tags for AWS resources"
}

variable "aws_account" {
  type        = string
  default     = ""
  description = "AWS account number that will be accessed by Jenkins"
}

variable "iam_role" {
  type        = string
  default     = ""
  description = "Name of an IAM role to be assumed by Jenkins"
}

variable "principal_arn" {
  type        = string
  default     = ""
  description = "Principal ARN used in the assume policy for the Jenkins service role"
}