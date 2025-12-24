

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy_enabled ? 1 : 0
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.max_images} images"
        selection = {
          # tagStatus   = "any"
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.max_images
        }
        action = {
          type = "expire"
        }
      }, 
      {
        rulePriority = 2
        description  = "Expire tagged images older than 30 days"
        selection = {
          tagStatus   = "tagged"
          tagPrefixList = ["v"] # Required when tagStatus is "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_replication_configuration" "this" {
  replication_configuration {
    rule {
      destination {
        region      = "us-east-1"   # target region
        # registry_id = "606891810694" # same account (change if cross-account)
        registry_id = data.aws_caller_identity.current.account_id
      }
    }
  }
}

