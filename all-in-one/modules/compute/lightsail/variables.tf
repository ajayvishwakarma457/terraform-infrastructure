variable "name" {
  description = "Lightsail instance name"
  type        = string
}

variable "availability_zone" {
  description = "AZ for Lightsail"
  type        = string
}

variable "blueprint_id" {
  description = "OS or app blueprint"
  type        = string
  default     = "amazon_linux_2"
}

variable "bundle_id" {
  description = "Instance plan"
  type        = string
}

variable "key_pair_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_snapshot" {
  description = "Whether to create an initial snapshot"
  type        = bool
  default     = false
}

variable "disk_size_gb" {
  type        = number
  description = "Size of Lightsail instance disk in GB"
  default     = 20
}
