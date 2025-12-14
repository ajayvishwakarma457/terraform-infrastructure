output "instance_name" {
  value = aws_lightsail_instance.this.name
}

output "public_ip" {
  value = aws_lightsail_static_ip.this.ip_address
}
