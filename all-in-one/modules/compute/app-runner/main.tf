

resource "aws_apprunner_service" "this" {
  service_name = var.app_name
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  source_configuration {
    authentication_configuration {
      #access_role_arn = aws_iam_role.apprunner_ecr_access.arn
      access_role_arn = var.apprunner_ecr_access_role_arn
    }

    image_repository {
      image_repository_type = "ECR"
      #image_identifier = "${module.ecr.repository_url}:${var.image_tag}"
      image_identifier = "${var.ecr_repository_url}:${var.image_tag}"

      image_configuration {
        port = var.container_port
      }
    }

    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "1024"   # 1 vCPU
    memory = "2048"   # 2 GB
  }


  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 20
    timeout             = 10
    healthy_threshold   = 1
    unhealthy_threshold = 10
  }

  tags = {
    Name = var.app_name
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = "${var.app_name}-scaling"
  min_size        = 1
  max_size        = 5
  max_concurrency = 50
}

