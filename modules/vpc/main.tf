# ------------- VPC definition ------------ #

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# ------------- Internet Gateway definition ------------ #

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

# ------------- Subnets definition ------------ #

resource "aws_subnet" "private-eu-west-3a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "eu-west-3a"

  tags = {
    "Name"                                      = "private-eu-west-3a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-eu-west-3b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "eu-west-3b"

  tags = {
    "Name"                                      = "private-eu-west-3b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-eu-west-3c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "eu-west-3c"

  tags = {
    "Name"                                      = "private-eu-west-3c"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-3a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-eu-west-3a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-3b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.128.0/19"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-eu-west-3b"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-3c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.160.0/19"
  availability_zone       = "eu-west-3c"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-eu-west-3c"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# ------------- NAT GAteway definition ------------ #

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-eu-west-3a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# ------------- Route tables definition ------------ #

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw.id
      nat_gateway_id             = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-eu-west-3a" {
  subnet_id      = aws_subnet.private-eu-west-3a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-3b" {
  subnet_id      = aws_subnet.private-eu-west-3b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-3c" {
  subnet_id      = aws_subnet.private-eu-west-3c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-3a" {
  subnet_id      = aws_subnet.public-eu-west-3a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-3b" {
  subnet_id      = aws_subnet.public-eu-west-3b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-3c" {
  subnet_id      = aws_subnet.public-eu-west-3c.id
  route_table_id = aws_route_table.public.id
}


# ---------- EFS Security group ---------- #

resource "aws_security_group" "efs-mount-sg" {
  vpc_id = aws_vpc.main.id
  name_prefix = "efs-mount-sg"
  description = "Amazon EFS for EKS, SG for mount target"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}
