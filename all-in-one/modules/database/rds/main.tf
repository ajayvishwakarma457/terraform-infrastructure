
resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.username
  password = var.password
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  multi_az            = var.multi_az
  apply_immediately = true
  publicly_accessible = false

  backup_retention_period = var.backup_retention_days
  skip_final_snapshot     = true

  deletion_protection = var.deletion_protection

  tags = var.tags
}
