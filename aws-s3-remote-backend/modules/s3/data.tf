data "aws_region" "state" {
}

data "aws_region" "replica" {
  provider = aws.replica
}