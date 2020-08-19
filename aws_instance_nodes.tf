resource "aws_instance" "node" {
  count                       = var.node_count
  ami                         = data.aws_ami.rhel_base.id
  instance_type               = var.node_ec2_instance_type
  ebs_optimized               = true
  monitoring                  = true
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.master_node_profile.name
  subnet_id                   = sort(data.aws_subnet_ids.private.ids)[0]
  user_data                   = data.template_file.user_data_node[count.index].rendered
  key_name                    = local.ssh_key_name

  vpc_security_group_ids      = [
    aws_security_group.openshift_master.id,
    aws_security_group.common_private_sg.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = var.node_root_disk_size
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = var.node_data_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = false
  }

  #script templates need to be on S3 before starting the instance
  depends_on = [
    aws_s3_bucket_object.node_post_install_script
  ]

  tags = merge(local.common_tags,
  map("Name", "${upper(var.environment)}-INFRA-NODE-${count.index}"))

}