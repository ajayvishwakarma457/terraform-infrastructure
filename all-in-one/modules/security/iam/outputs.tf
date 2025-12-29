output "ec2_role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "IAM Role name for EC2"
}

output "devops_group_name" {
  value       = aws_iam_group.devops_group.name
  description = "Name of IAM DevOps group"
}

output "ajay_user_name" {
  value       = aws_iam_user.ajay_user.name
  description = "IAM username created for admin"
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "apprunner_ecr_access_role_arn" {
  value = aws_iam_role.apprunner_ecr_access.arn
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

