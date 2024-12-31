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
