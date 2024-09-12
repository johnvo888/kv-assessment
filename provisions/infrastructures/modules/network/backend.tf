terraform {
  backend "s3" {
    bucket = "kvasmt-infrastructure"
    key    = "provision/infra/network.tfstate"
    region = "ap-southeast-1"
  }
}
