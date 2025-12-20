output "log_group_arn" {
  value = aws_cloudwatch_log_group.route53.arn
}

output "iam_role_arn" {
  value = aws_iam_role.route53_query_logging.arn
}
