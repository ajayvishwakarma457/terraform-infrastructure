
module "vpc" {
  source = "./modules/network/vpc"
  project_name         = var.project_name
  aws_region           = var.aws_region
  common_tags          = var.common_tags
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}


module "iam" {
  source       = "./modules/security/iam"
  project_name = var.project_name
  common_tags  = var.common_tags
}

module "acm" {
  source = "./modules/security/acm"
  domain_name = var.zone_name
  subject_alternative_names = ["www.${var.zone_name}"]
  zone_id = module.route53.zone_id
  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}


module "route53" {
  source = "./modules/network/route53"
  zone_name  = var.zone_name
  create_zone = true
  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["1.2.3.4"] # [aws_instance.web.public_ip]
    }
  ]

  tags = {
    Client = "client-a"
    Env    = "dev"
  }
}
