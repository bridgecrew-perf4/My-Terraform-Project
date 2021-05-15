/*
Terraform template that builds IAM resources.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
}

# Terraform IAM policy
resource "aws_iam_policy" "terraform" {
  name = format(
    "AWSTerraformPolicy_%s",
    title(var.environment)
  )
  path        = "/"
  description = "IAM policy providing Terraform access to all resources required to add, update, and delete a state."

  policy = data.aws_iam_policy_document.terraform_document.json

  tags = local.tags
}