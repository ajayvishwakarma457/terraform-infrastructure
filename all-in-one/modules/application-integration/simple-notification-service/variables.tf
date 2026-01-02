
variable "name" {
  description = "SNS topic name"
  type        = string
}

variable "display_name" {
  description = "Display name for SNS topic (used for email/SMS)"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Enable FIFO topic"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication (FIFO only)"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ARN or alias for SNS encryption"
  type        = string
  default     = "alias/aws/sns"
}

variable "tags" {
  description = "Tags for SNS topic"
  type        = map(string)
  default     = {}
}

variable "email_subscriptions" {
  description = "List of email addresses to subscribe to SNS topic"
  type        = list(string)
  default     = []
}