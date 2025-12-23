
output "rds_endpoint" {
  # value = aws_db_instance.this.endpoint
  value = var.restore_from_snapshot ? aws_db_instance.restore[0].id : aws_db_instance.this[0].id
}

output "rds_id" {
  # value = aws_db_instance.this.id
  value = var.restore_from_snapshot ? aws_db_instance.restore[0].id : aws_db_instance.this[0].id
}
