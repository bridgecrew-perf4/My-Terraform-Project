/*
Variables used with the main Terraform template.
*/

variable "project_name" {
  type        = string
  default     = "aws-iam-service-user-group"
  description = "Name of Terraform project"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"
}

variable "profile" {
  type        = string
  default     = null
  description = "AWS profile name"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "default_tags" {
  type        = map(any)
  default     = {}
  description = "Default tags for AWS resources"
}

variable "policy_list" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
    "arn:aws:iam::117580903444:policy/assume-role-policy"
  ]
  description = "List of policy ARNs to attach to the user group"
}

variable "custom_iam_policy_actions" {
  type = map(any)
  default = {
    kms: [
      "Decrypt",
      "Encrypt",
      "GenerateDataKey"
    ]
  }
  description = "List of custom additional IAM actions needed by all services"
}