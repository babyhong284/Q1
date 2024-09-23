resource "aws_vpc" "main" {
  cidr_block = var.vpc_subnet
  
  tags = {
    Name     = "vpc-main"
    Resource = var.resource_tag
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name     = "rt-main"
    Resource = var.resource_tag
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name     = "rt-main-public"
    Resource = var.resource_tag
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[0].id
  }

  tags = {
    Name     = "rt-main-private"
    Resource = var.resource_tag
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Resource = var.resource_tag
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_subnet, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index % 3]
  map_public_ip_on_launch = true

  tags = {
    Name     = format("%s/%s","main-public",count.index)
    Resource = var.resource_tag
  }
}

resource "aws_subnet" "private" {
  count              = var.subnet_count
  vpc_id             = aws_vpc.main.id
  cidr_block         = cidrsubnet(var.vpc_subnet, 8, 100 + count.index)
  availability_zone  = data.aws_availability_zones.available.names[count.index % 3]

  tags = {
    Name     = format("%s/%s","main-private",count.index)
    Resource = var.resource_tag
  }
}

resource "aws_route_table_association" "public" {
  for_each       = {for idx, val in aws_subnet.public: idx => val}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = {for idx, val in aws_subnet.private: idx => val}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  count  = var.subnet_count >= 3 ? 3 : var.subnet_count
  domain = "vpc"

  tags = {
    Name     = format("%s-%s","main-nat-eip",count.index)
    Resource = var.resource_tag
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}

resource "aws_nat_gateway" "main" {
  for_each      = { for idx in range(var.subnet_count >= 3 ? 3 : var.subnet_count) : idx => idx }

  allocation_id = aws_eip.nat[each.value].id
  subnet_id     = aws_subnet.public[each.value].id

  tags = {
    Name     = format("%s-%s", "main-nat-gateway", each.value)
    Resource = var.resource_tag
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}
