# Security Group
resource "aws_security_group" "db" {
  name        = "${var.prefix}-db-sg"
  description = "Security group for ${var.prefix} RDS instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-db-sg"
  }
}

# Ingress Rule
resource "aws_security_group_rule" "db_ingress" {
  type              = "ingress"
  description       = "PostgreSQL from private subnets"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.db.id
}

# Egress Rule
resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}