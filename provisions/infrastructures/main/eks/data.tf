data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "kvasmt-infrastructure"
    key    = "env:/${terraform.workspace}/provisions/infra/network.tfstate"
    region = "ap-southeast-1"
  }
}