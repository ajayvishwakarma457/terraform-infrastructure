
resource "aws_lightsail_instance" "this" {
  name              = var.name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = var.key_pair_name
  user_data         = var.user_data
  tags = var.tags
}

resource "aws_lightsail_static_ip" "this" {
  name = "${var.name}-ip"
}

resource "aws_lightsail_static_ip_attachment" "this" {
  static_ip_name = aws_lightsail_static_ip.this.name
  instance_name = aws_lightsail_instance.this.name
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
