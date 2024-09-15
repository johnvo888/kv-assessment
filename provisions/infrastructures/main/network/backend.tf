terraform {
  backend "s3" {
    bucket = "kvasmt-infrastructure"
    key    = "provisions/infra/network.tfstate"
    region = "ap-southeast-1"
  }
}
