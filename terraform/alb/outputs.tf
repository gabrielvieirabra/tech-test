output "frontend_lb_sg" {
  value = aws_security_group.lb.id
}

output "backend_lb_sg" {
  value = aws_security_group.lb_backend.id
}