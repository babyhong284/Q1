resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]

  security_group_ids  = [
    aws_security_group.ssm.id
  ]

  tags = {
    Name     = "ssm-endpoint"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]

  security_group_ids  = [
    aws_security_group.ssm.id
  ]

  tags = {
    Name     = "ssm-endpoint"
    Resource = var.resource_tag
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for subnet in aws_subnet.public : subnet.id]

  security_group_ids  = [
    aws_security_group.ssm.id
  ]

  tags = {
    Name     = "ssm-endpoint"
    Resource = var.resource_tag
  }
}
