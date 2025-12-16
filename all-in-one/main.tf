
module "vpc" {
  source               = "./modules/network/vpc"
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
  source                    = "./modules/security/acm"
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  zone_id                   = module.route53.zone_id
  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "route53" {
  source      = "./modules/network/route53"
  zone_name   = var.domain_name
  create_zone = true
  records = [
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [module.ec2.public_ip]
    },
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = [module.ec2.public_ip] # [aws_instance.web.public_ip] 
    }
  ]

  tags = {
    Client = "client-a"
    Env    = "dev"
  }
}

module "web_sg" {
  source = "./modules/security/sg"

  name   = "web-sg-dev"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] #["YOUR_IP/32"]
    }
  ]

  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "ec2" {
  source             = "./modules/compute/ec2"
  name               = "web-dev"
  ami_id             = "ami-02b8269d5e85954ef"
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.web_sg.id]
  key_name           = "master-key-pair"
  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "s3_app" {
  source = "./modules/storage/s3"
  bucket_name = "spakcommgroup-app-dev"
  force_destroy = false
  lifecycle_rules = [
    {
      id               = "logs-archive"
      enabled          = true
      transitions      = [{ days = 30, storage_class = "STANDARD_IA" }]
      expiration_days  = 365
    }
  ]
  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "lightsail_web" {
  source = "./modules/compute/lightsail"

  name              = "web-dev"
  availability_zone = "ap-south-1a"
  bundle_id         = "nano_3_1"
  create_snapshot   = true 
  disk_size_gb = 50

  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

