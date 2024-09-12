data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "kvasmt-infrastructure"
    key    = "env:/${terraform.workspace}/provision/infra/network.tfstate"
    region = "ap-southeast-1"
  }
}