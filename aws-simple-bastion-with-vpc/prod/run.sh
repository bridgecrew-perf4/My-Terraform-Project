terraform init -input=false
terraform validate
terraform plan -out=tfplan -input=false
terraform apply -input=false tfplan
export ssh_key=id_rsa.pem
export ssh_user=ubuntu
export bastion_ip=$(terraform output -raw bastion_public_ip)
ssh -A -i ~/.ssh/$ssh_key $ssh_user@$bastion_ip