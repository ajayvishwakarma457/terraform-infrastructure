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
