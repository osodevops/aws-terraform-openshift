resource "aws_security_group" "openshift_master" {
  description = "Security group that allows traffic from into master node"
  name = "${upper(var.environment)}-OCP-MASTER-NODE-PUB-SG"
  vpc_id = data.aws_vpc.mgmt.id
  tags = {
    Name = "${upper(var.environment)}-OCP-MASTER-NODE-PUB-SG"
  }
}
  
resource "aws_security_group_rule" "openshift_master_ingress_rule1" {
  type         = "ingress"
  from_port    = "22"
  to_port    = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule2" {
  type         = "ingress"
  from_port    = "443"
  to_port    = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule3" {
  type         = "ingress"
  from_port    = "80"
  to_port    = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule4" {
  type         = "ingress"
  from_port    = "8053"
  to_port    = "8053"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule5" {
  type         = "ingress"
  from_port    = "8053"
  to_port    = "8053"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule6" {
  type         = "ingress"
  from_port    = "53"
  to_port    = "53"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule7" {
  type         = "ingress"
  from_port    = "53"
  to_port    = "53"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule8" {
  type         = "ingress"
  from_port    = "2379"
  to_port    = "2379"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule9" {
  type         = "ingress"
  from_port    = "2380"
  to_port    = "2380"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

#Allow Inbound to nodeport to access the app deployed on openshift.
resource "aws_security_group_rule" "openshift_master_ingress_rule10" {
  type         = "ingress"
  from_port    = "30000"
  to_port    = "32767"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule11" {
  type         = "ingress"
  from_port    = "8443"
  to_port    = "8443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule12" {
  type         = "ingress"
  from_port    = "4789"
  to_port    = "4789"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule13" {
  type         = "ingress"
  from_port    = "2049"
  to_port    = "2049"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule14" {
  type         = "ingress"
  from_port    = "2049"
  to_port    = "2049"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

# This allows us to get console into the pods
resource "aws_security_group_rule" "openshift_master_ingress_rule15" {
  type              = "ingress"
  from_port         = "10250"
  to_port           = "10250"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master_ingress_rule16" {
  type         = "ingress"
  from_port    = "8444"
  to_port    = "8444"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}

resource "aws_security_group_rule" "openshift_master-egress_rule1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.openshift_master.id
}