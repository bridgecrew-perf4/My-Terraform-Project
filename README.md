# My Terraform Project

My personal repository for practicing Terraform.

As an alternative to leveraging the [`workspace`](https://www.terraform.io/docs/language/state/workspaces.html) feature of Terraform, each environment is isolated from each other via *file layout*. The advantage here is that we can work on a feature workspace for a corresponding feature branch in each of the environments before promoting to production. While this may prove to be more laborious, it ensures that we adhere to a strict protocol so as to not disturb our production environment without validation.

## Terraform Project List

* [AWS S3 Remote Backend](./aws-s3-remote-backend/README.md)
* [AWS Simple Bastion with VPC](./aws-simple-bastion-with-vpc/README.md)
