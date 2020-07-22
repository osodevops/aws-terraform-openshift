resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.rhel_base.id
  instance_type               = var.ec2_instance_type
  ebs_optimized               = true
  monitoring                  = true
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  subnet_id                   = sort(data.aws_subnet_ids.public.ids)[0]

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = "20"
  }

  tags = {
    Name = "${upper(var.environment)}-OCP-BASTION"
  }
}