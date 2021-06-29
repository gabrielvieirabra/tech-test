resource "aws_db_subnet_group" "group" {
  name       = "mysql-rds-main"
  subnet_ids = var.private_db_subnet
}

resource "aws_security_group" "rds" {
  description = "Allow access to the RDS database instance"
  name        = "rds-backend-access"
  vpc_id      = var.master_vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    cidr_blocks = [var.backend_cidr]
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "mysql-backend-db"
  name                    = "backend"
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  db_subnet_group_name    = aws_db_subnet_group.group.name
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
}