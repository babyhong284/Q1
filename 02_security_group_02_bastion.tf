resource "aws_security_group" "bastion" {
  name        = "bastion_access"
  description = "bastion access thru SSM, no ingress port required"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name     = "bastion-sg"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_outbound" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
