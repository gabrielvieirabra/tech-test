
variable "vpc_cidr_block" {
  description = "VPC CIDR's block"
  default     = "10.0.0.0/16"
}

variable "pub_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "priv_subnet_cidr_block" {
  default = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}