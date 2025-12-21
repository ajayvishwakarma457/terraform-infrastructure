resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  associate_public_ip_address = var.associate_public_ip
  user_data              = var.user_data != null ? var.user_data : file("${path.module}/modules/compute/ec2/web-dev.sh")
  iam_instance_profile   = var.iam_instance_profile

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    prevent_destroy = false   # or false
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"   # 👈 this ENFORCES IMDSv2
  }

}


resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_ids[0]  # Attach to the second subnet
  security_groups = [var.security_group_ids[0]]  # Attach the first security group

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
    ManagedBy  = "terraform"
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


resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 1
  min_size         = 1
  max_size         = 3

  vpc_zone_identifier = var.subnet_ids #module.vpc.public_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}