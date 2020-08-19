module "ansible_resource_bucket" {
  source                  = "git::ssh://git@github.com/osodevops/aws-terraform-module-s3.git"
  s3_bucket_policy        = ""
  s3_bucket_name          = local.ansible_bucket_name
  common_tags             = var.common_tags
}

# Resources copied to S3 and used during provisioning.
resource "aws_s3_bucket_object" "inventory_file" {
  bucket      = local.ansible_bucket_name
  key         = "inventory.cfg"
  depends_on  = [module.ansible_resource_bucket, data.template_file.ansible_inventory]
  content     = data.template_file.ansible_inventory.rendered
}

resource "aws_s3_bucket_object" "master_post_install_script" {
  bucket      = local.ansible_bucket_name
  key         = "post_install_master.sh"
  depends_on  = [module.ansible_resource_bucket, data.template_file.master_post_install_script]
  content     = data.template_file.master_post_install_script.rendered
}

resource "aws_s3_bucket_object" "node_post_install_script" {
  bucket      = local.ansible_bucket_name
  key         = "post_install_node.sh"
  depends_on  = [module.ansible_resource_bucket, data.template_file.node_post_install_script]
  content     = data.template_file.node_post_install_script.rendered
}

data "template_file" "ansible_inventory" {
  template          = file("${path.module}/ansible/inventory.template.cfg")
  vars = {
    ssh_key_name    = local.ssh_key_name
    access_key      = aws_iam_access_key.openshift-aws-user.id
    secret_key      = aws_iam_access_key.openshift-aws-user.secret
    public_hostname = "${aws_instance.master_node[0].public_ip}.xip.io"
    cluster_id      = local.cluster_id
    infra_nodes     = join("\n", formatlist("%s openshift_node_group_name='node-config-infra'", aws_instance.master_node.*.private_dns))
    master_nodes    = join("\n", formatlist("%s openshift_node_group_name='node-config-master'", aws_instance.master_node.*.private_dns))
    compute_nodes   = join("\n", formatlist("%s openshift_node_group_name='node-config-compute'", aws_instance.node.*.private_dns))
  }

  depends_on = [
    aws_instance.node,
    aws_instance.master_node
  ]
}

data "template_file" "master_post_install_script" {
  template = file("${path.module}/scripts/post_install_master.sh")
  vars = {
    admin_username = var.web_console_admin_username
    admin_password = var.web_console_admin_password
  }
}

data "template_file" "node_post_install_script" {
  template = file("${path.module}/scripts/post_install_node.sh")
}
