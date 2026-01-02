
resource "aws_sns_topic" "this" {
  name = var.name

  display_name = var.display_name
  fifo_topic                  = var.fifo_topic

  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  kms_master_key_id = var.kms_key_id

  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  for_each = var.fifo_topic ? [] : toset(var.email_subscriptions)
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.value
}