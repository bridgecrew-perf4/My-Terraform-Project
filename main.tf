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
  region  = var.region
  profile = var.profile
}

module "vpc" {
  source                = "./modules/vpc"
  my_ip_address         = var.my_ip_address
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_a_cidr  = "10.0.0.0/24"
  private_subnet_a_cidr = "10.0.1.0/24"
  availability_zone     = var.availability_zone
  environment           = var.environment
}

module "ec2" {
  source            = "./modules/ec2"
  key_name          = var.key_name
  public_key        = var.public_key
  instance_type     = "t2.micro"
  public_subnet_id  = module.vpc.aws_public_subnet_id_a
  private_subnet_id = module.vpc.aws_private_subnet_id_a
  bastion_sg        = module.vpc.bastion_sg
  private_sg        = module.vpc.private_sg
  availability_zone = var.availability_zone
  environment       = var.environment
  depends_on = [
    module.vpc
  ]
}