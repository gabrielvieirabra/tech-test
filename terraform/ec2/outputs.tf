output "frontend_instance_id" {
  value = module.ec2_frontend.id
}

output "backend_instance_id" {
  value = module.ec2_backend.id
}