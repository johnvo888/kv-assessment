provider "aws" {
  region = "ap-southeast-1" 
}

terraform {
  backend "s3" {
    bucket = "kvasmt-infrastructure"
    key    = "provisions/infra/eks.tfstate"
    region = "ap-southeast-1"
  }
}