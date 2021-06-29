output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet_cidr" {
  value = var.private_cidr
}

output "private_db_subnet_cidr" {
  value = var.private_db_cidr
}

output "database_subnets" {
  value       = module.vpc.database_subnets
}