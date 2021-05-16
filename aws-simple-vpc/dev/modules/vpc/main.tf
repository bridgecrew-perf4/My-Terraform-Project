/*
Terraform template that builds VPC resources.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.public_subnets),
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
}

/*
VIRTUAL PRIVATE CLOUD
*/
# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr
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

# DHCP options set
resource "aws_vpc_dhcp_options" "dhcp" {
  tags = merge(
    {
      Name = "${var.environment}_dhcp"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# DHCP options set association
resource "aws_vpc_dhcp_options_association" "dhcp_association" {
  vpc_id = aws_vpc.my_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id

  lifecycle {
    create_before_destroy = true
  }
}

/*
SECURITY GROUP(S)
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
    self      = true
  }

  tags = local.tags

  depends_on = [
    aws_vpc.my_vpc
  ]

  lifecycle {
    create_before_destroy = true
  }
}

/*
ROUTES & ROUTE TABLES/ASSOCIATIONS
*/
# Default route table
resource "aws_default_route_table" "default_route" {
  default_route_table_id = "${var.environment}_default_route"

  tags = merge(
    {
      Name = "${var.environment}_default_route"
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

# Route table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    {
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

# Public route table association
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnet_a.id

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
PUBLIC SUBNET
*/
# Public subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name       = format(
        "%s_public_subnet_%s",
        var.environment,
        element(var.azs, count.index)
      )
      subnettype = "public"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

/*
PRIVATE SUBNET
*/
# Private subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name       = format(
        "%s_private_subnet_%s",
        var.environment,
        element(var.azs, count.index)
      )
      network    = "NAT"
      subnettype = "private"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

/*
NETWORK ACCESS CONTROL LISTS
*/
# Default network ACL
resource "aws_default_network_acl" "name" {
  default_network_acl_id = aws_vpc.my_vpc.default_network_acl_id
}

# Public network ACL
resource "aws_network_acl" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.my_vpc.id
  subnet_ids = aws_subnet.public.*.id

  ingress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(
    {
      Name = "${var.environment}_public_acl"
    },
    local.tags
  )
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