/*
Main Terraform template that builds the infrastructure defined in the modules.

Author: Chad Bartel
Date:   2021-05-14
*/

provider "aws" {}

provider "aws" {
  alias = "replica"
}