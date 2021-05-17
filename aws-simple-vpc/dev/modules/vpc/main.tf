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
  nat_gateway_count = 1
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
  domain_name = "us-west-2.compute.internal"

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
  vpc_id          = aws_vpc.my_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id

  lifecycle {
    create_before_destroy = true
  }
}

/*
PUBLIC SUBNET
*/
# Public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = format(
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
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = format(
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
PUBLIC ROUTES & ROUTE TABLES/ASSOCIATIONS
*/
# Route table for public subnet
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0

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
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id

  lifecycle {
    create_before_destroy = true
  }
}

# Public route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id

  lifecycle {
    create_before_destroy = true
  }
}

/*
PRIVATE ROUTES & ROUTE TABLES/ASSOCIATIONS
*/
# Route table for private subnet
resource "aws_route_table" "private" {
  count = local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name = format(
        "%s_%s_private_route_table",
        var.environment,
        element(var.azs, count.index)
      )
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
  count = local.nat_gateway_count

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.my_nat.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }
}

# Private route table association
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

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

  lifecycle {
    create_before_destroy = true
  }
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

  lifecycle {
    create_before_destroy = true
  }
}

# Private network ACL
resource "aws_network_acl" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.my_vpc.id
  subnet_ids = aws_subnet.private.*.id

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
      Name = "${var.environment}_private_acl"
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
# Elastic IP for NAT
resource "aws_eip" "my_eip" {
  count = 1

  vpc = true

  tags = merge(
    {
      Name = format(
        "%s_%s_nat_eip",
        var.environment,
        var.azs[0]
      )
      network = "NAT"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# NAT (network access translation)
resource "aws_nat_gateway" "my_nat" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.my_eip[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
      Name = format(
        "%s_%s_nat",
        var.environment,
        var.azs[0]
      )
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

# Internet gateway for internet access
resource "aws_internet_gateway" "my_igw" {
  count = length(var.public_subnets) > 0 ? 1 : 0

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