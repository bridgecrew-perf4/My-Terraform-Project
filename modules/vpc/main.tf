/*
Terraform template that builds a VPC.
*/

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}_vpc"
    env  = var.environment
  }
}

# Internet gateway for internet access
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.environment}_igw"
    env  = var.environment
  }
}

# Elastic IP for NAT
resource "aws_eip" "my_nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.id
  ]
}

# NAT (network access translation)
resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  depends_on = [
    aws_internet_gateway.my_igw,
    aws_subnet.public_subnet_a
  ]

  tags = {
    Name = "${var.environment}_nat"
    env  = var.environment
  }
}

# Public subnet
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_public_subnet_a"
    env  = var.environment
  }
}

# Private subnet
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_a_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}_private_subnet_a"
    env  = var.environment
  }
}

# Routing table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.environment}_public_route_table"
    env  = var.environment
  }
}

# Routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.environment}_private_route_table"
    env  = var.environment
  }
}

# Route for public internet
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Route for private internet
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my_nat.id
}

# Public route table association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

# Private route table association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private.id
}

# VPC default security group
resource "aws_security_group" "default" {
  name        = "${var.environment}_default_sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.my_vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    env = var.environment
  }
}