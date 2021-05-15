/*
Outputs from the DyanmoDB Terraform module.
*/

# DynamoDB lock table name
output "dynamodb_table" {
  value       = aws_dynamodb_table.lock.id
  description = "Name of the DynamoDB lock table"
}