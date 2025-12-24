
variable "description" {
  type        = string
  default     = "KMS key for ECR image encryption"
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "alias_name" {
  type        = string
  default     = "alias/ecr"
}

variable "tags" {
  type    = map(string)
  default = {}
}
