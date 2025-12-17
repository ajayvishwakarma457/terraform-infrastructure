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

variable "db_name" {
  type = string
}

variable "db_blueprint_id" {
  type = string
}

variable "db_bundle_id" {
  type = string
}

variable "master_database_name" {
  type = string
}

variable "db_master_user" {
  type = string
}

variable "db_master_password" {
  type      = string
  sensitive = true
}

variable "service_name" {
  type = string
}

variable "power" {
  type = string
  # valid: nano | micro | small | medium
}

variable "scale" {
  type = number
}

variable "container_image" {
  type = string
  # example: "nginx:latest" or "public.ecr.aws/nginx/nginx:latest"
}
