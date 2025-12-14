variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domains (SANs)"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
