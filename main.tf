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