output "ec2_instance_id" {
  value = aws_instance.wordpress_ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.wordpress_ec2.public_ip
}