# Public access from a list of pre-set IP's
resource "aws_security_group" "bastion_sg" {
  description = "Security group that allows ssh traffic from list of CIDR ranges"
  name        = "${upper(var.environment)}-OCP-BASTION-PUB-SG"
  vpc_id      = data.aws_vpc.mgmt.id

  tags = {
    Name = "${upper(var.environment)}-OCP-BASTION-PUB-SG"
  }
}

resource "aws_security_group_rule" "bastion_sg_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = flatten(var.allowed_ips)
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

# Private ssh if asigned then can be assessed
resource "aws_security_group" "bastion_private_sg" {
  description = "Security group that allows ssh traffic from itself"
  name        = "${upper(var.environment)}-OCP-BASTION-PRI-SG"
  vpc_id      = data.aws_vpc.mgmt.id

  tags = {
    Name = "${upper(var.environment)}-OCP-BASTION-PRI-SG"
  }
}

resource "aws_security_group_rule" "bastion_private_sg_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.bastion_private_sg.id
}

resource "aws_security_group_rule" "bastion_private_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_private_sg.id
}

