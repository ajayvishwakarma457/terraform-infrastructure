
resource "aws_lightsail_instance" "this" {
  name              = var.name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = var.key_pair_name
  user_data         = var.user_data
  tags              = var.tags
}

resource "aws_lightsail_static_ip" "this" {
  name = "${var.name}-ip"
}

resource "aws_lightsail_instance_public_ports" "this" {
  instance_name = aws_lightsail_instance.this.name

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

  port_info {
    protocol  = "tcp"
    from_port = 3000
    to_port   = 3000
  }

  port_info {
    protocol  = "tcp"
    from_port = 3100
    to_port   = 3100
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

}

resource "aws_lightsail_static_ip_attachment" "this" {
  static_ip_name = aws_lightsail_static_ip.this.name
  instance_name  = aws_lightsail_instance.this.name
}

# Create snapshot using AWS CLI
resource "null_resource" "lightsail_snapshot" {
  # Only create snapshot when variable is true
  count = var.create_snapshot ? 1 : 0

  # Recreate snapshot when instance changes
  triggers = {
    instance_id = aws_lightsail_instance.this.id
    # Remove timestamp from triggers if you only want snapshot on instance changes
    # Or keep it if you want a new snapshot on every apply
    snapshot_time = timestamp()
  }

  # Create the snapshot
  provisioner "local-exec" {
    command = <<-EOT
      echo "Creating Lightsail snapshot..."
      aws lightsail create-instance-snapshot \
        --instance-name ${aws_lightsail_instance.this.name} \
        --instance-snapshot-name ${var.name}-snapshot-${formatdate("YYYYMMDD-HHmmss", timestamp())} \
        --region ${var.availability_zone != "" ? replace(var.availability_zone, "/[a-z]$/", "") : "us-east-1"}
      
      if [ $? -eq 0 ]; then
        echo "Snapshot created successfully"
      else
        echo "Failed to create snapshot"
        exit 1
      fi
    EOT
  }

  depends_on = [aws_lightsail_instance.this]
}

resource "aws_lightsail_disk" "this" {
  name              = "${var.name}-disk-1"
  availability_zone = var.availability_zone
  size_in_gb        = var.disk_size_gb
  tags              = var.tags
}

resource "aws_lightsail_disk_attachment" "this" {
  disk_name     = aws_lightsail_disk.this.name
  instance_name = aws_lightsail_instance.this.name
  disk_path     = "/dev/xvdf"
}

resource "aws_lightsail_database" "this" {
  relational_database_name = var.db_name

  availability_zone = var.availability_zone

  blueprint_id = var.db_blueprint_id
  bundle_id    = var.db_bundle_id

  master_database_name = var.master_database_name
  master_username      = var.db_master_user
  master_password      = var.db_master_password

  publicly_accessible = false
  skip_final_snapshot   = false
  final_snapshot_name   = "${var.db_name}-final"

  tags = var.tags
}

resource "aws_lightsail_container_service" "this" {
  name  = var.service_name
  power = var.power        # nano | micro | small | medium
  scale = var.scale        # number of containers
  tags = var.tags
}

resource "aws_lightsail_container_service_deployment_version" "this" {
  service_name = aws_lightsail_container_service.this.name

  container {
    container_name = "app"
    image = var.container_image
    ports = {
      "80" = "HTTP"
    }
    environment = {
      NODE_ENV = "dev"
    }
  }

    # 🔴 THIS IS WHAT YOU WERE MISSING
  public_endpoint {
    container_name = "app"
    container_port = 80

    health_check {
      path                = "/"
      success_codes       = "200-399"
      interval_seconds    = 10
      timeout_seconds     = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }

}

