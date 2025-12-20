# Main AWS provider (your primary region)
provider "aws" {
  region = var.aws_region
}

# Secondary provider for ACM (required by CloudFront → must be us-east-1)
provider "aws" {
  # alias  = "us_east_1"
  alias  = "use1"
  region = "us-east-1"
}
