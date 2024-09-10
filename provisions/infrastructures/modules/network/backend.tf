terraform {
  backend "s3" {
    bucket = "kvasmt-infrastructure"
    key    = "provision/${terraform.workspace}-network.tfstate"
    region = "ap-southeast-1"
  }
}
