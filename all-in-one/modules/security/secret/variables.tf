variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "secret_value" {
  type      = map(any)
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
