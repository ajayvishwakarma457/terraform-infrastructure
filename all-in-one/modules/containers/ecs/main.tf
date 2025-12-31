
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

   setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 7
    lifecycle {
    ignore_changes = [name]
  }
}
# Task definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.container_image   # EXISTING ECR IMAGE
      essential = true

      cpu    = var.cpu
      memory = var.memory

      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]

       secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.secret_arn}:DB_PASSWORD::"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

    # AUTO-HEALING CONFIG
      healthCheck = {
        command = ["CMD-SHELL","node -e \"require('http').get('http://localhost:3000', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))\""]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  enable_execute_command = true
  # launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200


  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }


  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    # assign_public_ip = false # for production, use private subnets
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn == null ? [] : [1]
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.service_name
      container_port   = var.container_port
    }
  }

  # depends_on = [aws_iam_role_policy_attachment.execution]
  depends_on = [var.ecs_execution_policy_attached_id]

  
}



