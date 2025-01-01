variable "enable_dns_hostnames" {
  default = true

}
variable "enable_dns_support" {
  default = true

}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "subnet_cidr_block" {
  type    = string
  default = "10.0.1.0/24"

}

variable "ami_id" {
  default = "ami-0e9085e60087ce171" # Ubuntu 24.04 AMI for eu-west-1

}

variable "instance_type" {
  default = "t2.micro"

}

variable "associate_public_ip_address" {
  default = true

}

variable "map_public_ip_on_launch" {
  default = true

}

variable "environment" {
  default = "dev"

}