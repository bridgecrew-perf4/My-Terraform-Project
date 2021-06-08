/*
Data used with the main Terraform template.
*/

# Create IAM policy document for each IAM action key
data "aws_iam_policy_document" "this" {
  for_each = var.custom_iam_policy_actions

  statement {
    actions = formatlist(
      "${each.key}:%s",
      each.value
    )
    resources = ["*"]
  }
}