variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "acl" {
  description = "Bucket ACL"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket deletion with objects"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Block all public access"
  type        = bool
  default     = true
}

variable "encryption" {
  description = "Enable default SSE-S3 encryption"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Lifecycle rules"
  type = list(object({
    id      = string
    enabled = bool
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    expiration_days = number
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
