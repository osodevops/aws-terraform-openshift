# Private ssh if asigned then can be assessed
resource "aws_security_group" "common_private_sg" {
  description = "Security group that allows ssh traffic from itself"
  name        = "${upper(var.environment)}-OCP-COMMON-PRI-SG"
  vpc_id      = data.aws_vpc.mgmt.id

  tags = {
    Name = "${upper(var.environment)}-OCP-COMMON-PRI-SG"
  }
}

resource "aws_security_group_rule" "common_private_sg_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.common_private_sg.id
}

resource "aws_security_group_rule" "common_private_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.common_private_sg.id
}

