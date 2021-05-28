/*
Terraform data file for creating the Terraform backend bucket and object.
*/

# Format Terraform backend template file
data "template_file" "backend" {
  template = file("${path.module}/backend.tpl")
  vars = {
    region               = local.region
    profile              = local.profile
    session_name         = local.session_name
    bucket               = local.backend_bucket
    key                  = local.backend_key
    encrypt              = var.encrypt
    kms_key_id           = local.kms_key_id
    workspace_key_prefix = local.workspace_key_prefix
    dynamodb_table       = local.dynamodb_table
  }
}