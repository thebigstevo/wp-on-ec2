output "vpc_id" {
  value = aws_vpc.wp-vpc.id
  
}

output "public_subnet_id" {
  value = aws_subnet.wp-subnet.id
  
}

output "route_table_id" {
  value = aws_route_table.wp-rt.id
  
}

output "vpc_cidr_block" {
  value = var.vpc_cidr_block
  
}