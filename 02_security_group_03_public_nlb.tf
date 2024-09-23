resource "aws_security_group" "nlb" {
  name        = "nlb_access"
  description = "Allow HTTPS and cloudfront inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name     = "nlb-sg"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_cloudfront_inbound" {
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = var.appserver_port
  ip_protocol       = "tcp"
  to_port           = var.appserver_port
}

resource "aws_vpc_security_group_egress_rule" "nlb_all_outbound" {
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
