resource "aws_security_group" "default_ssh" {
  name        = "kvasmt-secgroup-default-ssh"
  description = "Security Group for executing ssh to all instances on kvasmt"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "kvasmt-secgroup-default-ssh"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Kiet VPN Singapore 9"
    cidr_blocks = ["138.199.60.181/32"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Kiet VPN Singapore 7"
    cidr_blocks = ["138.199.60.171/32"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "VPC IP Range"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "default_tcp" {
  name        = "kvasmt-secgroup-default-tcp"
  description = "Security Group for connecting HTTP/HTTPS to ALB on kvasmt"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "kvasmt-secgroup-default-tcp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Worldwide"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = null
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Worldwide"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = null
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
