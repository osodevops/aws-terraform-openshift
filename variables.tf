variable "common_tags" {
  type = map(string)
}

variable "master_node_count" {
  type = number
  default = 1
}

variable "node_count" {
  description = "Number of infra nodes, must have a minimum of 2"
  type = number
  default = 2
}

variable "ec2_instance_type" {
  type = string
  default = "t3a.small"
}

variable "master_ec2_instance_type" {
  type = string
  default = "t3a.xlarge"
}

variable "node_ec2_instance_type" {
  type = string
  default = "t3a.xlarge"
}

variable "master_node_root_disk_size" {
  type = number
  default = 30
}

variable "master_node_data_volume_size" {
  type = number
  default = 50
}

variable "node_root_disk_size" {
  type = number
  default = 30
}

variable "node_data_volume_size" {
  type = number
  default = 50
}

variable "allowed_ips" {
  type = list(string)
}

variable "environment" {
  type = string
}

locals {
  cluster_id          = "openshift-cluster-eu-west-2"
  cluster_name        = "openshift-cluster"
  common_tags = map(
    "Project", "openshift",
    "KubernetesCluster", local.cluster_name,
    "kubernetes.io/cluster/${local.cluster_name}", local.cluster_id
  )

  ssh_key_name        = "id_rsa.openshift"
  ansible_bucket_name = "${lower(data.aws_iam_account_alias.current.account_alias)}-${data.aws_caller_identity.current.account_id}-openshift-ansible-resources"
  ssh_key_bucket_name = "${lower(data.aws_iam_account_alias.current.account_alias)}-${data.aws_caller_identity.current.account_id}-keys-${data.aws_region.current.name}"
}