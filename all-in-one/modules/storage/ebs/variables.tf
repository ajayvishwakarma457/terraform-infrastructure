variable "availability_zone" {
  description = "AZ where the EBS volume will be created"
  type        = string
}

variable "size" {
  description = "EBS volume size in GB"
  type        = number
}

variable "type" {
  description = "EBS volume type (gp3, gp2, io1, etc)"
  type        = string
  default     = "gp3"
}

variable "name" {
  description = "Name tag for the EBS volume"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_id" {
  description = "ID of the EC2 instance to attach the EBS volume to"
  type        = string
}

variable "device_name" {
    description = "Name of the device"
    type = string
    default = "/dev/xvdf"
}