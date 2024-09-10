# 1. Keypairs
variable "public_key_path_development" {
  type        = string
  description = <<DESCRIPTION
Keypair name used with ec2 instances on development environment
Path to the SSH public key to be used for development authentication.
Example: ~/.ssh/terraform_development.pub
DESCRIPTION
}

variable "public_key_path_staging" {
  type        = string
  description = <<DESCRIPTION
Keypair name used with ec2 instances on staging environment
Path to the SSH public key to be used for staging authentication.
Example: ~/.ssh/terraform_staging.pub
DESCRIPTION
}

variable "public_key_path_tool" {
  type        = string
  description = <<DESCRIPTION
Keypair name used with ec2 instances on staging environment
Path to the SSH public key to be used for staging authentication.
Example: ~/.ssh/terraform_tool.pub
DESCRIPTION
}
