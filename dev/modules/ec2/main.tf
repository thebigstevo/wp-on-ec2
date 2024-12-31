resource "aws_instance" "wordpress_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.wp-subnet.id
  security_groups             = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = var.associate_public_ip_address

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    database_password = "yourpassword"
  }
}
