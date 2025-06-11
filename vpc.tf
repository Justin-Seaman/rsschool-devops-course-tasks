# VPC
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
    Name = "jsrs-az1-pub1"
  }
}
# Private Subnet in AZ2
resource "aws_subnet" "jsrs-az2-priv1" {
  vpc_id            = aws_vpc.jsrs-vpc.id
  cidr_block        = var.az2_priv1_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "jsrs-az1-pub1"
  }
}
#Internet Gateway for Public Subnets
resource "aws_internet_gateway" "jsrs-igw" {
  vpc_id = aws_vpc.jsrs-vpc.id

  tags = {
    Name = "jsrs-igw"
  }
}