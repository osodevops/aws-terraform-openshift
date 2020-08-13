data "template_file" "user_data_master" {
  count = var.master_node_count
  template = file("${path.module}/scripts/user_data_master.sh")

  vars = {
    count              = count.index
    private_dns_zone   = aws_route53_zone.internal.name
    region             = data.aws_region.current.name
  }
}

data "template_file" "user_data_node" {
  count = var.node_count
  template = file("${path.module}/scripts/user_data_node.sh")
  vars = {
    count              = count.index
    private_dns_zone   = aws_route53_zone.internal.name
    region             = data.aws_region.current.name
  }
}

data "template_file" "user_data_bastion" {
  template = file("${path.module}/scripts/user_data_bastion.sh")
  vars = {
    private_dns_zone = aws_route53_zone.internal.name
    s3_ansible_bucket = local.ansible_bucket_name
    ssh_key_bucket = local.ssh_key_bucket_name
    ssh_key_name = local.ssh_key_name
  }
}
