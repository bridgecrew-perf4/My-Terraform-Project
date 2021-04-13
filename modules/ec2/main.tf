/*
Terraform template that builds an EC2 instance.
*/

data "template_file" "instance_user_data" {
  template = file("./modules/ec2/instance_user_data.tpl")

  vars = {
    tpl_secret = "test"
  }
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  user_data     = data.template_file.instance_user_data.rendered

  tags = {
    Name = "${var.environment}_ec2"
    env = var.environment
  }
}