
resource "aws_sqs_queue" "this" {
  name                      = var.fifo ? "${var.name}.fifo" : var.name
  fifo_queue                = var.fifo
  content_based_deduplication = var.fifo ? var.content_based_deduplication : null

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  max_message_size           = var.max_message_size

  kms_master_key_id = var.kms_key_id
  sqs_managed_sse_enabled = var.kms_key_id == null ? var.sqs_managed_sse : null

  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  count = var.enable_dlq ? 1 : 0

  name       = var.fifo ? "${var.name}-dlq.fifo" : "${var.name}-dlq"
  fifo_queue = var.fifo

  message_retention_seconds = var.dlq_message_retention_seconds
  tags = var.tags
}

resource "aws_sqs_queue_policy" "this" {
  # count     = length(var.queue_policy) > 0 ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  # policy    = var.queue_policy
  policy    = data.aws_iam_policy_document.queue_policy.json
}

data "aws_iam_policy_document" "queue_policy" {
  statement {
    sid    = "AllowConsumerAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.consumer_role_arn]
    }

    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]

    resources = [aws_sqs_queue.this.arn]
  }
}