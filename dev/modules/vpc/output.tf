output "vpc_cidr_block" {
  value = var.vpc_cidr_block
  
}

output "vpc_id" {
  value = aws_vpc.wp_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.wp_subnet.id
}