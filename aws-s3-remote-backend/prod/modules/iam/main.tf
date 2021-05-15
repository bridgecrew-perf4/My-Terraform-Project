/*
Terraform template that builds IAM resources.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
}

# Terraform IAM service policy
resource "aws_iam_policy" "terraform_policy" {
  name = format(
    "AWSTerraformPolicy_%s",
    title(var.environment)
  )
  path        = "/"
  description = "IAM policy providing Terraform access to all resources required to add, update, and delete a state."

  policy = data.aws_iam_policy_document.terraform_document.json

  tags = local.tags
}

# Terraform IAM role
resource "aws_iam_role" "terraform_role" {
  name = format(
    "AWSTerraformRole_%s",
    title(var.environment)
  )
  path        = "/"
  description = "value"

  assume_role_policy = data.aws_iam_policy_document.terraform_assume.json

  tags = local.tags
}

# Assume Terraform IAM service policy
resource "aws_iam_policy_attachment" "attach" {
  name = format(
    "AWSTerraformAttachment_%s",
    title(var.environment)
  )
  roles = [
    aws_iam_role.terraform_role.name
  ]
  policy_arn = aws_iam_policy.terraform_policy.arn
}