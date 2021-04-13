/*
Main Terraform template that builds the infrastructure defined in the modules.

Author: Chad Bartel
Date:   2021-04-03
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

# module "vpc" {
#   source            = "./modules/vpc"
#   vpc_cidr    = "10.0.0.0/16"
#   public_subnet_a_cidr = "10.0.0.0/24"
#   private_subnet_a_cidr = "10.0.1.0/24"
#   environment = var.environment
# }

module "ec2" {
  source    = "./modules/ec2"
  ami       = "ami-830c94e3"
  environment = var.environment
  # subnet_id = module.vpc.aws_subnet_id
}