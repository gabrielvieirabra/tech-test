resource "aws_lb" "nginx" {
  name               = "frontend-main"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets

  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "nginx" {
  name        = "tg-nginx"
  protocol    = "HTTP"
  vpc_id      = var.master_vpc_id
  target_type = "instance"
  port = 80

  health_check {
    path = "/"
  }

  depends_on = [
    aws_lb.nginx
  ]
}

resource "aws_lb_target_group_attachment" "frontend_attach" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = var.frontend_instance_id
  port             = 80
}

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

resource "aws_security_group" "lb" {
  description = "Allow access to application Load Balancer"
  name        = "frontend-lb"
  vpc_id      = var.master_vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# backend
resource "aws_lb" "backend_lb" {
  name               = "backend-main"
  internal           = true
  load_balancer_type = "application"
  subnets            = [var.private_subnet_1, var.private_subnet_2]

  security_groups = [aws_security_group.lb_backend.id]
}

resource "aws_lb_target_group" "backend_app" {
  name        = "tg-backend"
  protocol    = "HTTP"
  vpc_id      = var.master_vpc_id
  target_type = "instance"
  port = 8080

  depends_on = [
    aws_lb.backend_lb
  ]
}

resource "aws_lb_target_group_attachment" "backend_attach" {
  target_group_arn = aws_lb_target_group.backend_app.arn
  target_id        = var.backend_instance_id
  port             = 8080
}

resource "aws_lb_listener" "backend_app" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_app.arn
  }
}

resource "aws_security_group" "lb_backend" {
  description = "Allow access to application Load Balancer"
  name        = "backend-lb"
  vpc_id      = var.master_vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = [var.frontend_cidr]
  }

  egress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}