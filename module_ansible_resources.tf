module "ansible_resource_bucket" {
  source                  = "git::ssh://git@github.com/osodevops/aws-terraform-module-s3.git"
  s3_bucket_policy        = ""
  s3_bucket_name          = local.ansible_bucket_name
  common_tags             = var.common_tags
}


resource "aws_s3_bucket_object" "inventory_file" {
  bucket  = local.ansible_bucket_name
  key     = "inventory.cfg"
  depends_on = [module.ansible_resource_bucket, data.template_file.ansible_inventory]
  content = data.template_file.ansible_inventory.rendered
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/ansible/inventory.template.cfg")
  vars = {
    ssh_key_name = local.ssh_key_name
    access_key = aws_iam_access_key.openshift-aws-user.id
    secret_key = aws_iam_access_key.openshift-aws-user.secret
    public_hostname = "${aws_instance.master_node[0].public_ip}.xip.io"
    master_inventory = aws_instance.master_node[0].private_dns
    master_hostname = aws_instance.master_node[0].private_dns
    cluster_id = local.cluster_id
    master_nodes = "${join("\n", formatlist("%s openshift_node_group_name='node-config-master'", aws_instance.master_node.*.private_dns))}"
    compute_nodes = "${join("\n", formatlist("%s openshift_node_group_name='node-config-compute'", aws_instance.node.*.private_dns))}"
  }

  depends_on = [
    aws_instance.node,
    aws_instance.master_node
  ]
}

locals {

}