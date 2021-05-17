/*
Variables used with the main Terraform template.
*/

variable "project_name" {
  type        = string
  default     = "aws-simple-bastion-with-vpc"
  description = "Name of Terraform project"
}

variable "environment" {
  type        = string
  default     = "cert"
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