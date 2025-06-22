# VPC Definition
resource "aws_vpc" "jsrs-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "jsrs-vpc"
  }
}
# Public Subnet in AZ1
resource "aws_subnet" "jsrs-az1-pub1" {
  vpc_id            = aws_vpc.jsrs-vpc.id
  cidr_block        = var.az1_pub1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "jsrs-az1-pub1"
  }
}
# Private Subnet in AZ1
resource "aws_subnet" "jsrs-az1-priv1" {
  vpc_id            = aws_vpc.jsrs-vpc.id
  cidr_block        = var.az1_priv1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "jsrs-az1-priv1"
  }
}
# Public Subnet in AZ2
resource "aws_subnet" "jsrs-az2-pub1" {
  vpc_id            = aws_vpc.jsrs-vpc.id
  cidr_block        = var.az2_pub1_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "jsrs-az2-pub1"
  }
}
# Private Subnet in AZ2
resource "aws_subnet" "jsrs-az2-priv1" {
  vpc_id            = aws_vpc.jsrs-vpc.id
  cidr_block        = var.az2_priv1_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "jsrs-az2-pub1"
  }
}
#Internet Gateway for Public Subnets
resource "aws_internet_gateway" "jsrs-igw" {
  vpc_id = aws_vpc.jsrs-vpc.id

  tags = {
    Name = "jsrs-igw"
  }
}
# Route Table for Public Subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "public-route-table"
  }
}
# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.jsrs-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
# Route Table for Private Subnets
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.jsrs-az1-pub1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.jsrs-az2-pub1.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.jsrs-az1-priv1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.jsrs-az2-priv1.id
}

# Key Pair for SSH Access
resource "aws_key_pair" "ubuntu-kp" {
  key_name   = var.ssh_keypair_name
  public_key = var.ssh_keypair_public_key
}