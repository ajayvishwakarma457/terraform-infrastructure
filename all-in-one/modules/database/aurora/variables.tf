variable "cluster_identifier" {
  type = string
}

variable "engine_version" {
  type    = string
  # default = "8.0.mysql_aurora.3.05.2"
  default = "5.7.mysql_aurora.2.11.1"
}

variable "instance_class" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "database_name" {
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

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}
