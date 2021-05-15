/*
Terraform template that builds IAM resources.
*/

# Local variables
locals {
  lock_key_id = "LockID"
  tags = {
    module = path.module
  }
}

# Terraform DynamoDB lock table
resource "aws_dynamodb_table" "lock" {
  name         = "${var.environment}-tf-remote-state-lock"
  hash_key     = local.lock_key_id
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = local.lock_key_id
    type = "S"
  }

  tags = local.tags
}