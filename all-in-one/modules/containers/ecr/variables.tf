
# variable "aws_region" {
#   type        = optional(string)
#   description = "AWS region"
# }

variable "repository_name" {
  type        = string
  description = "ECR repository name"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  default     = true
}

variable "encryption_type" {
  type        = string
  default     = "AES256"
}

variable "lifecycle_policy_enabled" {
  type    = bool
  default = true
}

variable "max_images" {
  type    = number
  default = 10
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for ECR encryption"
  default     = null
}

