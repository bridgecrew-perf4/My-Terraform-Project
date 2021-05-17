/*
Variables used with the VPC Terraform module.
*/

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment name"
}

variable "azs" {
  type        = list(any)
  default     = null
  description = "AWS availability zone(s)"
}

variable "cidr" {
  type        = string
  default     = null
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(any)
  default     = null
  description = "CIDR blocks for the public subnets"
}

variable "private_subnets" {
  type        = list(any)
  default     = null
  description = "CIDR blocks for the private subnets"
}