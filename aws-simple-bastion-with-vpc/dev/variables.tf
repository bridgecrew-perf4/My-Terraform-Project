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

variable "availability_zone" {
  type        = string
  default     = null
  description = "AWS availability zone"
}

variable "key_name" {
  type        = string
  default     = null
  description = "SSH key name"
}

variable "public_key" {
  type        = string
  default     = null
  description = "SSH public key"
}

variable "ami" {
  type        = string
  default     = null
  description = "Amazon Machine Instance identifier"
}

variable "instance_type" {
  type        = string
  default     = null
  description = "EC2 instance type"
}

variable "vpc_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the VPC"
}

variable "public_subnet_a_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the public subnet"
}

variable "private_subnet_a_cidr" {
  type        = string
  default     = null
  description = "CIDR block for the private subnet"
}

variable "my_ip_address" {
  type        = string
  default     = null
  description = "My public IP address"
}