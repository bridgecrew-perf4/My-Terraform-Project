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

variable "backend_bucket" {
  type        = string
  default     = ""
  description = "Name of S3 bucket used in the backend configuration"
}

variable "bucket" {
  type        = string
  default     = ""
  description = "Name of S3 bucket to create"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "AWS S3 KMS key id used to encrypt objects in the bucket"
}

variable "session_name" {
  type        = string
  default     = ""
  description = "Name of Terraform session"
}

variable "key" {
  type        = string
  default     = ""
  description = "S3 bucket object key"
}

variable "backend_key" {
  type        = string
  default     = ""
  description = "S3 bucket object key"
}

variable "encrypt" {
  type        = bool
  default     = true
  description = "Option to either encrypt the state file or not"
}

variable "workspace_key_prefix" {
  type        = string
  default     = ""
  description = "Prefix to use when using a Terraform workspace"
}

variable "dynamodb_table" {
  type        = string
  default     = ""
  description = "Name of DynamoDB table to lock the Terraform remote state"
}