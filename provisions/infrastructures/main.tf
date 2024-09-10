provider "aws" {
  region = var.aws_region
}

# Fetch the VPC information from remote state using workspace-specific state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "kvasmt-infrastructure"
    key    = "${terraform.workspace}/network.tfstate"  # Workspace-specific key
    region = "ap-southeast-1"
  }
}

# Use the remote state outputs for VPC
# module "eks" {
#   source = "./modules/eks"

#   cluster_name = "${terraform.workspace}-eks-cluster"
#   vpc_id       = data.terraform_remote_state.vpc.outputs.vpc_id
#   subnet_ids   = data.terraform_remote_state.vpc.outputs.private_subnets
# }

# module "ec2_tools" {
#   source        = "./modules/ec2"
#   environment   = terraform.workspace
#   instance_type = var.instance_type
#   vpc_id        = data.terraform_remote_state.vpc.outputs.vpc_id
#   subnet_ids    = data.terraform_remote_state.vpc.outputs.public_subnets
# }