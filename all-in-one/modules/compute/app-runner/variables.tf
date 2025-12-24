
variable "ecr_repository_url" {
  type = string
}

variable "apprunner_ecr_access_role_arn" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}
