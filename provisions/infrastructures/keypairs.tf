resource "aws_key_pair" "keypair_development" {
  key_name   = "${var.project_name}-development"
  public_key = file(var.public_key_path_development)
}
resource "aws_key_pair" "keypair_staging" {
  key_name   = "${var.project_name}-staging"
  public_key = file(var.public_key_path_staging)
}

