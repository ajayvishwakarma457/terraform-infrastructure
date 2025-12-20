
resource "aws_cloudwatch_log_group" "route53" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days
  tags              = var.tags
}

resource "aws_iam_role" "route53_query_logging" {
  name = "route53-query-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "route53.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "route53_query_logging" {
  role = aws_iam_role.route53_query_logging.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.route53.arn}:*"
    }]
  })
}


resource "aws_cloudwatch_log_resource_policy" "route53" {
  policy_name = "route53-query-logging-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.route53.arn}:*"
      }
    ]
  })
}

