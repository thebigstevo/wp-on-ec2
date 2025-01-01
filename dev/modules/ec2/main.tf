resource "aws_instance" "wordpress_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.ssm_instance_profile

  user_data = data.template_file.user_data.rendered

  tags = {
    Name = var.instance_name  
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    DB_NAME     = var.database,
    DB_USER     = var.db_user,
    DB_PASSWORD = var.database_password
  }
}

