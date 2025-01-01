resource "aws_vpc" "wp_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "wp-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "wp_subnet" {
  vpc_id            = aws_vpc.wp_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "wp-subnet"
  }
}

resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
    Name = "wp-igw"
  }
}

resource "aws_route_table" "wp_rt" {
  vpc_id = aws_vpc.wp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_igw.id
  }
  tags = {
    Name = "wp-rt"
  }
}

resource "aws_route_table_association" "wp_rta" {
  subnet_id      = aws_subnet.wp_subnet.id
  route_table_id = aws_route_table.wp_rt.id
}

