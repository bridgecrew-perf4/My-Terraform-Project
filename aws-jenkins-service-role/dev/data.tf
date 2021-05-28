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

# IAM policy services access document
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

  # EC2
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:RequestSpotInstances",
      "ec2:DeleteTags",
      "ec2:CreateTags",
      "ec2:DescribeRegions",
      "ec2:RunInstances",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:StopInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:GetConsoleOutput",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeImages",
      "ec2:CancelSpotInstanceRequests",
      "iam:PassRole",
      "ec2:StartInstances",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSubnets",
      "ec2:DescribeKeyPairs"
    ]
    resources = ["*"]
  }

  # IAM
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  # ECR registry
  statement {
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:ReplicateImage"
    ]
    resources = [
      "arn:aws:ecr:${local.region}:${local.aws_account}:repository/*"
    ]
  }

  # ECR repo
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:TagResource",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = ["*"]
  }
}