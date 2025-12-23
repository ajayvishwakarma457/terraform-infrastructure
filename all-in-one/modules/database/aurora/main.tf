########################################
# Aurora Cluster (Normal Creation)
########################################
resource "aws_rds_cluster" "this" {
  count = var.restore_from_snapshot ? 0 : 1

  cluster_identifier = var.cluster_identifier
  engine             = "aurora-mysql"
  engine_version     = var.engine_version

  database_name   = var.database_name
  master_username = var.username
  master_password = var.password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  backup_retention_period = var.backup_retention_days
  preferred_backup_window = "02:00-03:00"

  storage_encrypted = true

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.cluster_identifier}-final"

  tags = var.tags
}

########################################
# Aurora Cluster (Restore from Snapshot)
########################################
resource "aws_rds_cluster" "restore" {
  count = var.restore_from_snapshot ? 1 : 0

  cluster_identifier  = "${var.cluster_identifier}-restore"
  snapshot_identifier = var.snapshot_identifier
  engine              = "aurora-mysql"

  master_username = var.username
  master_password = var.password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  storage_encrypted = true

  tags = var.tags
}

########################################
# Select Active Cluster (CRITICAL PART)
########################################
locals {
  active_cluster_id = var.restore_from_snapshot ? aws_rds_cluster.restore[0].id : aws_rds_cluster.this[0].id
}

########################################
# Aurora Cluster Instances
########################################
resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = local.active_cluster_id

  instance_class = var.instance_class
  engine         = "aurora-mysql"

  publicly_accessible = false

  tags = var.tags
}
