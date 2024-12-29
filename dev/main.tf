resource "aws_vpc" "wp-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "wp-vpc"
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "wp-subnet" {
  vpc_id = aws_vpc.wp-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_internet_gateway" "wp-igw" {
  vpc_id = aws_vpc.wp-vpc.id
  tags = {
    Name = "wp-igw"
  }
}

resource "aws_route_table" "wp-rt" {
  vpc_id = aws_vpc.wp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp-igw.id
  }
  tags = {
    Name = "wp-rt"
  }
}

resource "aws_route_table_association" "wp-rta" {
  subnet_id = aws_subnet.wp-subnet.id
  route_table_id = aws_route_table.wp-rt.id
}