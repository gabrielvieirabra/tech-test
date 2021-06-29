module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = var.private_cidr
  database_subnets    = var.private_db_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
  }
}