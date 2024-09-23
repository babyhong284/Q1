resource "aws_security_group" "ssm" {
  name        = "vpc_endpoint_access"
  description = "security group for vpc endpoint access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name     = "vpc-endpoint-sg"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_inbound" {
  security_group_id = aws_security_group.ssm.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "vpc_endpoint_outbound" {
  security_group_id = aws_security_group.ssm.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
