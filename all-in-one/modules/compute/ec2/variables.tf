variable "name" {
  description = "EC2 instance name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

# variable "subnet_id" {
#   description = "Subnet ID"
#   type        = string
# }

variable "subnet_ids" {
  description = "Subnet s IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Attach public IP"
  type        = bool
  default     = true
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

variable "iam_instance_profile" {
  type = string
  description = "IAM Instance Profile to attach to EC2"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
