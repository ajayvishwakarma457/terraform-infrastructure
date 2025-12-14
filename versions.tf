terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tanvora-terraform-state-001"
    key            = "infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tanvora-terraform-lock"
    encrypt        = true
  }

}