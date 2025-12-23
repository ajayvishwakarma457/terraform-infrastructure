
variable "identifier" {
  type = string
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "db_subnet_group_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "backup_window" {
  type    = string
  default = "02:00-03:00"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_database_authentication_enabled" {
  type = bool
  default = false
}

variable "restore_from_snapshot" {
  type    = bool
  default = false
}

variable "snapshot_identifier" {
  type    = string
  default = null
}

variable "restore_from_pitr" {
  type    = bool
  default = false
}

variable "pitr_restore_time" {
  type    = string
  default = null
}
