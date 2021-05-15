/*
Terraform template that builds an EC2 instance.
*/

# Local variables
locals {
  tags = {
    module = path.module
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = var.public_key

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  user_data                   = data.template_file.instance_user_data.rendered
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids = [
    var.bastion_sg
  ]

  tags = merge(
    {
      Name = "${var.environment}_bastion_host"
    },
    local.tags
  )

  depends_on = [
    aws_key_pair.key
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "private" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = false
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  user_data                   = data.template_file.instance_user_data.rendered
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids = [
    var.private_sg
  ]

  tags = merge(
    {
      Name = "${var.environment}_private_ec2"
    },
    local.tags
  )

  depends_on = [
    aws_key_pair.key
  ]

  lifecycle {
    create_before_destroy = true
  }
}