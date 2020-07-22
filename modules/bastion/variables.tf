variable "common_tags" {
  type = map(string)
}

variable "ec2_instance_type" {
  type = string
  default = "t3a.small"
}

variable "environment" {
  type = string
}

locals {
  ssh_key_name = "id_rsa.openshift"
  ssh_key_bucket_name = "${lower(data.aws_iam_account_alias.current.account_alias)}-${data.aws_caller_identity.current.account_id}-keys-${data.aws_region.current.name}"
}