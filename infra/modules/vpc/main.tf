# vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id
}

# public subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.my-vpc.id
  availability_zone = var.az_1
  cidr_block = var.public_subnet_1_cidr
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.my-vpc.id
  availability_zone = var.az_2
  cidr_block = var.public_subnet_2_cidr
}

# private subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.my-vpc.id
  availability_zone = var.az_1
  cidr_block = var.private_subnet_1_cidr
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.my-vpc.id
  availability_zone = var.az_2
  cidr_block = var.private_subnet_2_cidr
}

# elastic IPs
resource "aws_eip" "elastic-ip-1" {
  domain   = "vpc"
}

resource "aws_eip" "elastic-ip-2" {
  domain   = "vpc"
}

# NAT gateways
resource "aws_nat_gateway" "NAT-1" {
  allocation_id = aws_eip.elastic-ip-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "NAT-2" {
  allocation_id = aws_eip.elastic-ip-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# public route table
resource "aws_route_table" "public-subnet-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# public route tables associations
resource "aws_route_table_association" "public-subnet-1-rtba" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-subnet-rtb.id
}

resource "aws_route_table_association" "public-subnet-2-rtba" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-subnet-rtb.id
}

# private route tables
resource "aws_route_table" "private-subnet-rtb-1" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-1.id
  }
}

resource "aws_route_table" "private-subnet-rtb-2" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-2.id
  }
}

# private route table associations
resource "aws_route_table_association" "private-subnet-1-rtba" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-subnet-rtb-1.id
}

resource "aws_route_table_association" "private-subnet-2-rtba" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-subnet-rtb-2.id
}