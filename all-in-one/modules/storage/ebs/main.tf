
# create an EBS volume
resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}


# attach the EBS volume to an EC2 instance
resource "aws_volume_attachment" "this" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
  force_detach = false
}

# snapshot the EBS volume
resource "aws_ebs_snapshot" "this" {
  volume_id = aws_ebs_volume.this.id
  tags = {
    Name        = "web-dev-data-snap-v1"
    Project     = "tanvora"
    Environment = "dev"
    ManagedBy   = "terraform"
  }

  lifecycle {
   prevent_destroy = true
  }
}


# detach the EBS volume
resource "aws_volume_attachment" "ebs_attach" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
}
