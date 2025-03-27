resource "aws_db_instance" "this" {
  identifier                  = "${var.prefix}-postgres"
  allocated_storage           = var.allocated_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  db_subnet_group_name        = var.db_subnet_group_name
  vpc_security_group_ids      = [aws_security_group.db.id]
  skip_final_snapshot         = true
  deletion_protection         = var.environment == "prod" ? true : false
  backup_retention_period     = var.environment == "prod" ? 7 : 1
  multi_az                    = var.environment == "prod" ? true : false

  lifecycle {
    ignore_changes = [
      password
    ]
  }
}
