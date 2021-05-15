/*
Variables used with the main Terraform template.
*/

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment name"
}

variable "profile" {
  type        = string
  default     = "default"
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

variable "s3_bucket" {
  type        = string
  default     = "terraform-state"
  description = "Name of the S3 bucket"
}

variable "bucket_key" {
  type        = string
  default     = "/network"
  description = "Path to the state file inside the S3 bucket. When using a non-default workspace, the state path will be /workspace_key_prefix/workspace_name/key."
}

variable "dynamodb_endpoint" {
  type        = string
  default     = ""
  description = "Custom endpoint for the AWS DynamoDB API."
}

variable "dynamodb_table" {
  type        = string
  default     = ""
  description = "Name of DynamoDB Table to use for state locking and consistency. The table must have a primary key named 'LockID' with type of string."
}