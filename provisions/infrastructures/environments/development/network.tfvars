project_name = "kvasmt"

environment        = "development"

vpc_cidr           = "10.0.0.0/16"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

public_subnets     = ["10.0.0.0/19", "10.0.32.0/19"]

private_subnets    = ["10.0.96.0/19", "10.0.128.0/19"]

enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false

enable_vpn_gateway = false

