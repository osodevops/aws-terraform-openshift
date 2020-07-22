resource "aws_key_pair" "ssh" {
  key_name   = local.ssh_key_name
  public_key = tls_private_key.ssh.public_key_openssh
}
