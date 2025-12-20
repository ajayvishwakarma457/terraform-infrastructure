
variable "log_group_name" {
  type        = string
  description = "CloudWatch log group name for Route53 query logs"
}

variable "retention_in_days" {
  type        = number
  default     = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}
