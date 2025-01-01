variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true

}
variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true

}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"

}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0e9085e60087ce171" # Ubuntu 24.04 AMI for eu-west-1

}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"

}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the EC2 instance"
  type        = bool
  default     = true

}

variable "map_public_ip_on_launch" {
  default = true

}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
  default     = "dev"

}