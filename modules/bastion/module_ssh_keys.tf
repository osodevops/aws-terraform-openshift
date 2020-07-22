module "keys_bucket" {
  source                  = "git::ssh://git@github.com/osodevops/aws-terraform-module-s3.git"
  s3_bucket_policy        = ""
  s3_bucket_name          = local.ssh_key_bucket_name
  common_tags             = var.common_tags
}

resource "aws_s3_bucket_object" "pem-private" {
  bucket  = local.ssh_key_bucket_name
  key     = local.ssh_key_name
  content = tls_private_key.ssh.private_key_pem
  depends_on = [module.keys_bucket]
}

resource "aws_s3_bucket_object" "ssh-public" {
  bucket  = local.ssh_key_bucket_name
  key     = "${local.ssh_key_name}.pub"
  content = tls_private_key.ssh.public_key_openssh
  depends_on = [module.keys_bucket]
}
