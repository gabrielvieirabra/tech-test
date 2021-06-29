provider "aws" {
    region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"

  master_vpc_id = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnets[0]
  frontend_private_subnet = module.vpc.private_subnets[0]
  backend_private_subnet = module.vpc.private_subnets[2]
  frontend_lb_sg = module.alb.frontend_lb_sg
  backend_lb_sg = module.alb.backend_lb_sg
  frontend_cidr = module.vpc.private_subnet_cidr[0]
}

module "alb" {
  source = "./alb"
  master_vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnet_1 = element(module.vpc.private_subnets, 2)
  private_subnet_2 = element(module.vpc.private_subnets, 3)
  frontend_instance_id = module.ec2.frontend_instance_id[0]
  frontend_cidr = module.vpc.private_subnet_cidr[0]
  backend_instance_id = module.ec2.backend_instance_id[0]
}

module "rds" {
  source = "./rds"
  master_vpc_id = module.vpc.vpc_id
  private_db_subnet = module.vpc.database_subnets
  backend_cidr = module.vpc.private_db_subnet_cidr[0]
  db_username = var.db_username
  db_password = var.db_password
}