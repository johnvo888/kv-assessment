project_name = "kvasmt"

region         = "ap-southeast-1"
availability_zones = ["ap-southeast-1a"]

kubernetes_version = "1.30"
desired_size   = 4
max_size       = 4
min_size       = 4
instance_types = ["t3.large"]

ssh_public_key_path = "../../keypairs/kvasmt-development.pub"

namespace   = "assessment"
environment = "development"
stage       = "dev"
name        = "infra-main"