/*
Terraform data file for building the Jenkins service role.
*/

# IAM role assume policy document
data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "AWS"
      identifiers = [
        local.principal_arn
      ]
    }
  }
}

# TODO: IAM policy services access document
data "aws_iam_policy_document" "services" {
  # S3
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetObject",
      "s3:DeletObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
}