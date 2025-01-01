variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The IDs of the VPC security groups"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the EC2 instance"
  type        = bool
}

variable "ssm_instance_profile" {
  description = "The IAM instance profile for SSM"
  type        = string
}
variable "database" {
  description = "The database to connect to"
  type        = string

}

variable "db_user" {
  description = "The database user"
  type        = string
  
}

variable "database_password" {
  description = "The password for the database"
  type        = string
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}