/*
Variables used with the S3 Terraform template.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "s3_bucket" {
  type        = string
  default     = null
  description = "Name of the S3 bucket"
}

variable "bucket_key" {
  type        = string
  default     = null
  description = "Path to the state file inside the S3 bucket. When using a non-default workspace, the state path will be /workspace_key_prefix/workspace_name/key."
}