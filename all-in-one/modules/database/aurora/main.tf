resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier

  engine         = "aurora-mysql"
  engine_version = var.engine_version

  database_name   = var.database_name
  master_username = var.username
  master_password = var.password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  backup_retention_period = var.backup_retention_days
  preferred_backup_window = "02:00-03:00"

  storage_encrypted = true

  skip_final_snapshot = true

  tags = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id

  instance_class = var.instance_class
  engine         = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  publicly_accessible = false

  tags = var.tags
}
