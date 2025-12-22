resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[0]
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  user_data                   = var.user_data != null ? var.user_data : file("${path.module}/modules/compute/ec2/web-dev.sh")
  iam_instance_profile        = var.iam_instance_profile

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    prevent_destroy = false # or false
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # 👈 this ENFORCES IMDSv2
  }

}


resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_ids[0]           # Attach to the second subnet
  security_groups = [var.security_group_ids[0]] # Attach the first security group

  tags = {
    Name        = "web-dev-eni-2"
    Project     = "tanvora"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_network_interface_attachment" "this" {
  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.this.id
  device_index         = 1
}

resource "aws_ami_from_instance" "this" {
  name               = "web-dev-asg-v1"
  source_instance_id = aws_instance.this.id

  tags = {
    Name        = "web-dev-asg-v1"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "web-asg-"
  image_id      = aws_ami_from_instance.this.id
  instance_type = "t3.small"

  vpc_security_group_ids = var.security_group_ids #[module.web_sg.id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg"
    }
  }
}


resource "aws_autoscaling_group" "this" {
  name             = "web-asg"
  desired_capacity = 1
  min_size         = 1
  max_size         = 3

  vpc_zone_identifier = var.subnet_ids #module.vpc.public_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns         = [aws_lb_target_group.this.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      instance_warmup        = 60
    }
  }

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "this" {
  name                   = "cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

resource "aws_lb_target_group" "this" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "web-tg"
  }
}


resource "aws_lb" "this" {
  name               = "web-alb"
  load_balancer_type = "application"
  internal           = false

  subnets         = var.subnet_ids
  security_groups = [var.security_group_ids[0]]

  tags = {
    Name = "web-alb"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}


# resource "aws_autoscaling_group" "this" {
#   name = "web-asg"

#   min_size         = 1
#   max_size         = 3
#   desired_capacity = 1

#   vpc_zone_identifier = var.subnet_ids

#   launch_template {
#     id      = aws_launch_template.this.id
#     version = "$Latest"
#   }

#   target_group_arns = [
#     aws_lb_target_group.this.arn
#   ]

#   health_check_type         = "ELB"
#   health_check_grace_period = 120

#   tag {
#     key                 = "Name"
#     value               = "web-asg"
#     propagate_at_launch = true
#   }
# }
