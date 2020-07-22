resource "aws_security_group" "bastion-sg" {
  description = "Security group that allows ssh traffic from list of CIDR ranges"
  name        = "${upper(var.environment)}-OCP-BASTION-PUB-SG"
  vpc_id      = data.aws_vpc.mgmt.id

  tags = {
    Name = "${upper(var.environment)}-OCP-BASTION-PUB-SG"
  }
}

resource "aws_security_group_rule" "bastion-sg-ingress-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ips
  security_group_id = aws_security_group.bastion-sg.id
  description       = "Internal SSH traffic from ${var.allowed_ips}"
}

resource "aws_security_group_rule" "bastion-sg-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}

