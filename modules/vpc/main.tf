resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "main" {
  count = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = {
    Name = "main-nat-${count.index}"
  }
}

resource "aws_eip" "nat" {
  count = length(var.public_subnets)
  domain = "vpc"

  tags = {
    Name = "main-eip-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.main[*].id, count.index)
  }

  tags = {
    Name = "private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}