terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "sso_poweruser"
  region  = "us-west-2"
}

module "ec2" {
  source = "./modules/ec2"
}

output "instance_ip_addr" {
  description = "The private IP address of the main server instance."
  value       = aws_instance.example.private_ip
}
