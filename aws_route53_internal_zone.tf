//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "openshift.local"
  comment = "OpenShift Cluster Internal DNS"
  vpc {
    vpc_id = data.aws_vpc.mgmt.id
  }
  tags = {
    Name    = "OpenShift Internal DNS"
    Project = "openshift"
  }
}

//  Routes for 'master', 'node1' and 'node2'.
resource "aws_route53_record" "master_a_record" {
  count     = var.master_node_count
  zone_id   = aws_route53_zone.internal.zone_id
  name      = "master${count.index}.openshift.local"
  type      = "A"
  ttl       = 300
  records = [
    aws_instance.master_node[count.index].private_ip
  ]
  depends_on = [aws_instance.master_node]
}
resource "aws_route53_record" "node_a_record" {
  count     = var.node_count
  zone_id   = aws_route53_zone.internal.zone_id
  name      = "node${count.index}.openshift.local"
  type      = "A"
  ttl       = 300
  records = [
    aws_instance.node[count.index].private_ip
  ]
  depends_on = [aws_instance.node]
}
