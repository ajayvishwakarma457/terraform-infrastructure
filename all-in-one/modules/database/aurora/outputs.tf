
output "cluster_endpoint" {
  # value = aws_rds_cluster.this.endpoint
  value = var.restore_from_snapshot ? aws_rds_cluster.restore[0].reader_endpoint : aws_rds_cluster.this[0].reader_endpoint
}

output "reader_endpoint" {
  # value = aws_rds_cluster.this.reader_endpoint
  value = var.restore_from_snapshot ? aws_rds_cluster.restore[0].endpoint : aws_rds_cluster.this[0].endpoint
}

