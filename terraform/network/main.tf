# vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.pub_subnet.id
  tags = {
    Name = "private_nat_gateway"
  }
}

# internet gateway
# to-be-done

# public subnet
resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# private subnets
resource "aws_subnet" "priv_subnet" {
  count                   = length(var.priv_subnet_cidr_block)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.priv_subnet_cidr_block[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet_${var.priv_subnet_cidr_block[count.index]}"
  }
}

# app lb
resource "aws_security_group" "allow_app_lb_access" {
  name   = "allow_access"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_outside_access"
  }
}

# internal app lb
