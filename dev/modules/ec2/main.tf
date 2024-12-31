resource "aws_instance" "wordpress_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = var.public_subnet_id
  security_groups       = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  iam_instance_profile = var.ssm_instance_profile

  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    database_password = "yourpassword"
  }
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "public_subnet_id" {
  type = string
  
}

variable "ssm_instance_profile" {
  type = string
  
}