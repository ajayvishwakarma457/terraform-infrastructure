variable "zone_name" {
  description = "Domain name (example.com)"
  type        = string
}

variable "create_zone" {
  description = "Create hosted zone or use existing"
  type        = bool
  default     = true
}

variable "zone_id" {
  description = "Existing hosted zone ID (if create_zone = false)"
  type        = string
  default     = null
}

variable "records" {
  description = "DNS records"
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
    set_identifier = optional(string)
    weight         = optional(number)
    latency_region = optional(string)
    geo_location = optional(object({
      country     = optional(string)
      continent   = optional(string)
      subdivision = optional(string)
    }))
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
