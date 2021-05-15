terraform init -input=false
terraform validate
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan