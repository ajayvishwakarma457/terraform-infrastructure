
output "ami_id" {
  value = aws_ami_from_instance.this.id
}

output "ami_name" {
  value = aws_ami_from_instance.this.name
}
