
variable "aws_region" {}

variable "cluster_name" {}
variable "service_name" {}

variable "container_image" {
  description = "ECR image URI (already created)"
}

variable "container_port" {
  default = 3000
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "512"
}

variable "desired_count" {
  default = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_group_arn" {
  default = null
}

variable "assign_public_ip" {
  description = "Assign public IP to ECS tasks (debug only)"
  type        = bool
  default     = false
}

variable "secret_arn" {
  type = string
}

variable "execution_role_arn" {
  type        = string
  description = "ECS execution role ARN"
}

variable "task_role_arn" {
  type        = string
  description = "ECS task role ARN"
}


