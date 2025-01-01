module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_support
}

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"  
  environment = var.environment
}

module "ec2" {
  source                      = "./modules/ec2"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  public_subnet_id            = module.vpc.public_subnet_id
  ssm_instance_profile        = module.iam.ssm_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [module.security_groups.wordpress_sg_id]
  database_password           = var.database_password
  database = var.database
  db_user = var.db_user
  instance_name               = var.instance_name  
}

