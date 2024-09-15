# Runbook

## Terraform 
Install terraform version 1.8.5

## Instructions
1. Setup account AWS with admin roles
2. Update code in provisions/infrastructure/base/main.tf
3. Run command
```sh
terraform init
terraform plan -out base.terraform
terraform apply "base.terraform"
```
