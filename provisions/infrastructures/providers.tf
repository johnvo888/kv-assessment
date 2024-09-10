provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "kvasmt-infrastructure"
    key    = "provisopns/${terraform.workspace}/infra.tfstate"
    region = "ap-southeast-1"
  }
}