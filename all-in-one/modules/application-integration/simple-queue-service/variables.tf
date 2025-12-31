variable "name" { type = string }

variable "fifo" {
  type    = bool
  default = false
}

variable "content_based_deduplication" {
  type    = bool
  default = true
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}

variable "message_retention_seconds" {
  type    = number
  default = 345600 # 4 days
}

variable "delay_seconds" {
  type    = number
  default = 0
}

variable "receive_wait_time_seconds" {
  type    = number
  default = 20
}

variable "max_message_size" {
  type    = number
  default = 262144
}

variable "enable_dlq" {
  type    = bool
  default = true
}

variable "max_receive_count" {
  type    = number
  default = 5
}

variable "dlq_message_retention_seconds" {
  type    = number
  default = 1209600 # 14 days
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "sqs_managed_sse" {
  type    = bool
  default = true
}

variable "queue_policy" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
