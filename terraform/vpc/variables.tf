variable "private_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_db_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}