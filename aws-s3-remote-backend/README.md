# AWS S3 Remote Backend

Terraform project which creates a remote backend using Amazon S3 and DynamoDB.

From the documentation:

    Stores the state as a given key in a given bucket on Amazon S3. This backend also supports state locking and consistency checking via Dynamo DB, which can be enabled by setting the dynamodb_table field to an existing DynamoDB table name. A single DynamoDB table can be used to lock multiple remote state files. Terraform generates key names that include the values of the bucket and key variables.

Reference for project: [Terraform Reference - S3 Standard Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
Inspiration for project: [terraform-aws-remote-state-s3-backend](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws/latest)

## Features

## Usage

## Requirements

## Providers

## Inputs

## Outputs
