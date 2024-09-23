resource "aws_security_group" "appserver" {
  name        = "appserver_access"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name     = "appserver-sg"
    Resource = var.resource_tag
  }
}


resource "aws_vpc_security_group_egress_rule" "appserver_all_outbound" {
  security_group_id = aws_security_group.appserver.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
