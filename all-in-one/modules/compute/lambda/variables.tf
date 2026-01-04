
variable "function_name" {
  type = string
}

variable "runtime" {
  type = string
}

variable "handler" {
  type = string
}

variable "filename" {
  type = string
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 3
}

variable "architecture" {
  type    = string
  default = "x86_64"
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "role_name" {
  type = string
}

variable "dlq_target_arn" {
  type    = string
  default = null
}

variable "provisioned_concurrency" {
  type    = number
  default = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}
