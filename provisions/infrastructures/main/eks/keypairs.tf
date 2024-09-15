resource "aws_key_pair" "keypair" {
  key_name   = "${var.project_name}-${terraform.workspace}"
  public_key = file(var.ssh_public_key_path)
}