
# ACM Terraform Module

## What this module does
- Creates an AWS ACM SSL/TLS certificate
- Supports root domain and multiple subdomains (SANs)
- Uses DNS-based validation
- Automatically validates the certificate using Route 53
- Ensures zero downtime during certificate replacement

## Resources created
- aws_acm_certificate  
- aws_route53_record (DNS validation records)  
- aws_acm_certificate_validation  

## Validation flow
- ACM generates DNS validation details
- Route 53 CNAME records are created automatically
- Terraform waits until the certificate status is **ISSUED**
- Certificate becomes ready for use with AWS services

## Inputs
- `domain_name` – Primary domain name
- `subject_alternative_names` – List of additional domain names
- `zone_id` – Route 53 Hosted Zone ID
- `tags` – Tags for resource management

## Outputs
- `certificate_arn` – ARN of the validated ACM certificate

## Supported AWS services
- Application Load Balancer (ALB)
- CloudFront
- API Gateway
- App Runner

## Important notes
- DNS validation is required for auto-renewal
- Certificates are managed and renewed by AWS
- ACM certificates cannot be downloaded
- For CloudFront, certificate must be created in `us-east-1`
- For ALB / App Runner, region must match the service region

## Best practices
- Always use DNS validation
- Always include `aws_acm_certificate_validation`
- Use low TTL for faster DNS validation
- Tag certificates for ownership and environment tracking

## Example usage
```hcl
module "acm" {
  source = "./modules/security/acm"

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  zone_id                   = module.route53.zone_id

  tags = {
    Env = "dev"
  }
}
