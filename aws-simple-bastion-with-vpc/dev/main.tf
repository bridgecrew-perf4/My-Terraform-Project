/*
Main Terraform template that builds the infrastructure defined in the modules.

Author:   Chad Bartel
Date:     2021-04-03
Revised:  2021-07-14
*/


# Create AWS Terraform provider
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = merge(
      {
        env       = var.environment
        workspace = terraform.workspace
      },
      var.default_tags
    )
  }
}


# Local variables
locals {
  myip                = var.my_ip_address == "" ? chomp(data.http.myip.body) : var.my_ip_address
  vpc_cidr            = var.vpc_cidr == "" ? "10.0.0.0/16" : var.vpc_cidr
  public_subnet_cidr  = var.vpc_cidr == "" ? "10.0.0.0/24" : var.public_subnet_cidr
  private_subnet_cidr = var.vpc_cidr == "" ? "10.0.1.0/24" : var.private_subnet_cidr
  availability_zone   = var.availability_zone == "" ? "us-west-2a" : var.availability_zone
}


# Execute VPC module
module "vpc" {
  source              = "./modules/vpc"
  my_ip_address       = local.myip
  vpc_cidr            = local.vpc_cidr
  public_subnet_cidr  = local.public_subnet_cidr
  private_subnet_cidr = local.private_subnet_cidr
  availability_zone   = local.availability_zone
  environment         = var.environment
}

# Execute EC2 module
module "ec2" {
  depends_on = [
    module.vpc
  ]

  source            = "./modules/ec2"
  key_name          = var.key_name
  public_key        = var.public_key
  instance_type     = "t2.micro"
  public_subnet_id  = module.vpc.aws_public_subnet_id
  private_subnet_id = module.vpc.aws_private_subnet_id
  bastion_sg        = module.vpc.bastion_sg
  private_sg        = module.vpc.private_sg
  availability_zone = local.availability_zone
  environment       = var.environment
}