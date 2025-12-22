output "vpc_id" {
  value       = aws_vpc.tanvora_vpc.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnets[*].id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnets[*].id
  description = "List of private subnet IDs"
}


output "db_subnet_group_name" {
  value       = aws_db_subnet_group.db.name
  description = "DB subnet group for RDS/Aurora"
}