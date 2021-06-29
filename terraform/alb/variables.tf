variable "master_vpc_id" {
}

variable "public_subnets" {
  type = list(any)
}

variable "private_subnet_1" {}
variable "private_subnet_2" {}

variable "frontend_instance_id" {}

variable "backend_instance_id" {}

variable "frontend_cidr" {
  
}