variable "source_instance_id" {
  description = "EC2 instance ID to create AMI from"
  type        = string
}

variable "name" {
  description = "AMI name"
  type        = string
}

variable "snapshot_without_reboot" {
  description = "Create AMI without rebooting instance"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
