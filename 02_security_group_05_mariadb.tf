locals {
  db_port = 3306
}

resource "aws_security_group" "db" {
  name        = "db_access"
  description = "Allow sql inbound traffic from appserver and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name     = "db-sg"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_appserver_inbound" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.appserver.id
  from_port                    = local.db_port
  ip_protocol                  = "tcp"
  to_port                      = local.db_port
}

resource "aws_vpc_security_group_ingress_rule" "db_bastion_inbound" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = local.db_port
  ip_protocol                  = "tcp"
  to_port                      = local.db_port
}


resource "aws_vpc_security_group_egress_rule" "db_all_outbound" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
