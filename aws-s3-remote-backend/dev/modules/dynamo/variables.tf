/*
Variables used with the IAM Terraform template.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}