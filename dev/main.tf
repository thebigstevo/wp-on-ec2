module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_support
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = module.vpc.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  public_subnet_id = module.vpc.public_subnet_id
  ssm_instance_profile = module.iam.ssm_instance_profile
}

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"  
  
}

# resource "aws_vpc" "wp-vpc" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_support   = var.enable_dns_support
#   enable_dns_hostnames = var.enable_dns_support
#   tags = {
#     Name = "wp-vpc"
#   }
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_subnet" "wp-subnet" {
#   vpc_id            = aws_vpc.wp-vpc.id
#   cidr_block        = var.subnet_cidr_block
#   availability_zone = data.aws_availability_zones.available.names[0]
# }

# resource "aws_internet_gateway" "wp-igw" {
#   vpc_id = aws_vpc.wp-vpc.id
#   tags = {
#     Name = "wp-igw"
#   }
# }

# resource "aws_route_table" "wp-rt" {
#   vpc_id = aws_vpc.wp-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.wp-igw.id
#   }
#   tags = {
#     Name = "wp-rt"
#   }
# }

# resource "aws_route_table_association" "wp-rta" {
#   subnet_id      = aws_subnet.wp-subnet.id
#   route_table_id = aws_route_table.wp-rt.id
# }

# resource "aws_security_group" "wordpress_sg" {
#   name   = "wordpress_sg"
#   vpc_id = aws_vpc.wp-vpc.id
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "wordpress_sg"
#   }
# }


# resource "aws_instance" "wordpress_ec2" {
#   ami           = var.ami
#   instance_type = var.instance_type

#   subnet_id                   = aws_subnet.wp-subnet.id
#   security_groups             = [aws_security_group.wordpress_sg.id]
#   associate_public_ip_address = var.associate_public_ip_address

#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

#   user_data = data.template_file.user_data.rendered
# }

# data "template_file" "user_data" {
#   template = file("${path.module}/user-data.sh")

#   vars = {
#     database_password = "yourpassword"
#   }
# }
