module "ansible_resource_bucket" {
  source                  = "git::ssh://git@github.com/osodevops/aws-terraform-module-s3.git"
  s3_bucket_policy        = ""
  s3_bucket_name          = local.ansible_bucket_name
  common_tags             = var.common_tags
}


resource "aws_s3_bucket_object" "inventory_file" {
  bucket  = local.ansible_bucket_name
  key     = "inventory.cfg"
  depends_on = [module.ansible_resource_bucket]
  content = data.template_file.ansible_inventory.rendered
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/ansible/inventory.template.cfg")
  vars = {
    ssh_key_name = local.ssh_key_name
    access_key = aws_iam_access_key.openshift-aws-user.id
    secret_key = aws_iam_access_key.openshift-aws-user.secret
    public_hostname = "${aws_instance.master_node[0].public_ip}.xip.io"
    master_inventory = "master0.openshift.local"
    master_hostname = "master0.openshift.local"
    node1_hostname = "node0.openshift.local"
    node2_hostname = "node1.openshift.local"
    cluster_id = local.cluster_id
  }
}