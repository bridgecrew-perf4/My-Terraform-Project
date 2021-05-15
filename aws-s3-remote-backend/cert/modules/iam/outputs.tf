/*
Outputs from the IAM Terraform module.
*/

# Terraform IAM service role arn
output "terraform_role" {
  value       = aws_iam_role.terraform_role.arn
  description = "Arn of the Terraform IAM service role"
}