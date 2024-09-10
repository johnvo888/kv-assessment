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

variable "project_name" {
  type        = string
  default     = ""
  description = "Naming of current project"
}

variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

