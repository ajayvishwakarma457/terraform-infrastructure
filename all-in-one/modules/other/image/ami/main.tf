
resource "aws_ami_from_instance" "this" {
  name               = var.name
  source_instance_id = var.source_instance_id
  snapshot_without_reboot = var.snapshot_without_reboot
  tags = var.tags
}
