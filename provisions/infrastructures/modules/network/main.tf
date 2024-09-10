module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  name = "kvasmt-vpc-main"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.0.0.0/19","10.0.32.0/19","10.0.64.0/19"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "base"
  }
}
