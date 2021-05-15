/*
Terraform template that builds a VPC.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "${var.environment}_vpc"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

/*
    INTERNET ACCESS RESOURCES
*/
# Internet gateway for internet access
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name = "${var.environment}_igw"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for NAT
resource "aws_eip" "my_nat_eip" {
  vpc = true

  tags = merge(
    {
      Name    = "${var.environment}_nat_eip"
      network = "NAT"
    },
    local.tags
  )

  depends_on = [
    aws_internet_gateway.my_igw
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# NAT (network access translation)
resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = merge(
    {
      Name = "${var.environment}_nat"
    },
    local.tags
  )

  depends_on = [
    aws_internet_gateway.my_igw,
    aws_subnet.public_subnet_a
  ]

  lifecycle {
    create_before_destroy = true
  }
}

/*
    PUBLIC SUBNET
*/
# Public subnet
resource "aws_subnet" "public_subnet_a" {
  availability_zone       = var.availability_zone
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name       = "${var.environment}_public_subnet_a"
      subnettype = "public"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name       = "${var.environment}_public_route_table"
      subnettype = "public"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Route for public internet
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id

  lifecycle {
    create_before_destroy = true
  }
}

# Public route table association
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnet_a.id

  lifecycle {
    create_before_destroy = true
  }
}

/*
    PRIVATE SUBNET
*/
# Private subnet
resource "aws_subnet" "private_subnet_a" {
  availability_zone       = var.availability_zone
  cidr_block              = var.private_subnet_a_cidr
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name       = "${var.environment}_private_subnet_a"
      network    = "NAT"
      subnettype = "private"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge({
    Name       = "${var.environment}_private_route_table"
    subnettype = "private"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Route for private internet
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my_nat.id

  lifecycle {
    create_before_destroy = true
  }
}

# Private route table association
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_subnet_a.id

  lifecycle {
    create_before_destroy = true
  }
}

/*
    SECURITY GROUPS
*/
# VPC default security group
resource "aws_security_group" "default" {
  name        = "${var.environment}_default_sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.my_vpc.id

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

  tags = local.tags

  depends_on = [
    aws_vpc.my_vpc
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Bastion security group
resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}_bastion_sg"
  description = "Security group to allow SSH to bastion from my IP"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from my IP address"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.my_ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  depends_on = [
    aws_vpc.my_vpc
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Private instance security group (use bastion public ip)
resource "aws_security_group" "private_sg" {
  name        = "${var.environment}_private_sg"
  description = "Security group to allow SSH to private instances from bastion"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "SSH from bastion host IP"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  depends_on = [
    aws_security_group.bastion_sg
  ]

  lifecycle {
    create_before_destroy = true
  }
}