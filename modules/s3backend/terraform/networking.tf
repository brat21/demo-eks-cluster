data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.network.cidr_block
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "Main"
      Type = "Private"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = length(var.network.private_subnets[*]) > 0 ? length(var.network.private_subnets[*]) : 0

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.network.private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
    Type = "Private"
  }
}

resource "aws_subnet" "public" {
  count = length(var.network.public_subnets) > 0 ? length(var.network.public_subnets[*]) : 0

  cidr_block              = var.network.public_subnets[count.index]
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
    Type = "Public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name        = "Main IGW"
      Description = "Internet Gatewat for Main VPC"
    },
    var.tags,
  )
}

resource "aws_eip" "elastic_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = merge(
    {
      Name = "eip-main-vpc"
    },
    var.tags,
  )
}

resource "aws_nat_gateway" "nats" {
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"
  allocation_id     = aws_eip.elastic_ip.id
  depends_on        = [aws_internet_gateway.igw]

  tags = merge(
    {
      Name        = "NAT_Gateway"
      Description = "NAT Gateway for Main VPC"
    },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "Private-Route-Table"
      Type = "Private"
    },
    var.tags
  )
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nats.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private[*].id) > 0 ? length(aws_subnet.private[*]) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "Public-Route-Table"
      Type = "Public"
    },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id) > 0 ? length(aws_subnet.public[*]) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}