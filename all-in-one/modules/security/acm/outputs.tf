output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "status" {
  value = aws_acm_certificate.this.status
}
