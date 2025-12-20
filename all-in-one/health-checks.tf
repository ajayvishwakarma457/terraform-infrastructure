
resource "aws_route53_health_check" "primary" {
  fqdn              = "spakcommgroup.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
  tags = {
    Name = "primary-mumbai"
    Env  = "dev"
  }
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = "spakcommgroup.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
  tags = {
    Name = "primary-mumbai"
    Env  = "dev"
  }
}

# resource "aws_route53_health_check" "primary_string_match" {
#   fqdn              = "spakcommgroup.com"
#   port              = 80
#   type              = "HTTP"
#   resource_path     = "/health"
#   search_string     = "OK"
#   failure_threshold = 3
#   request_interval  = 30
#   tags = {
#     Name = "primary_string_match"
#     Env  = "dev"
#   }
# }

resource "aws_route53_health_check" "primary_https" {
  fqdn              = "spakcommgroup.com"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30
  tags = {
    Name = "primary_https"
    Env  = "dev"
  }
}

resource "aws_route53_health_check" "primary_tcp" {
  fqdn              = "spakcommgroup.com"
  port              = 22
  type              = "TCP"
  failure_threshold = 3
  request_interval  = 30
  tags = {
    Name = "primary_tcp"
    Env  = "dev"
  }
}