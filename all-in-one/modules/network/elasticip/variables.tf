variable "name" {
  description = "Name tag for Elastic IP"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_id" {
  description = "Instance ID to associate the Elastic IP with"
  type        = string
}