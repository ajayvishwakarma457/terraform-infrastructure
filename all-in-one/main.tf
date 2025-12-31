

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
  db_resource_id = var.db_resource_id
  aws_region     = var.aws_region
  # secret_arn = module.secret.secret_arn
  secret_arn = module.secret_ecs.secret_arn # for ecs module
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

    # For Simple Routing
    # {
    #   name    = ""
    #   type    = "A"
    #   ttl     = 300
    #   records = ["13.203.208.203"] # [module.ec2.public_ip]
    # },
    # For Simple Routing

    # For Weighted Routing
    # {
    #   name           = "@"
    #   type           = "A"
    #   ttl            = 300
    #   records        = ["15.207.111.124"]
    #   set_identifier = "instance-1"
    #   weight         = 80
    # },
    # {
    #   name           = "@"
    #   type           = "A"
    #   ttl            = 300
    #   records        = ["3.110.174.241"]
    #   set_identifier = "instance-2"
    #   weight         = 20
    # },
    # For Weighted Routing

    # For Latency Based Routing
    #  {
    #     name           = "@"
    #     type           = "A"
    #     ttl            = 300
    #     records        = ["13.203.208.203"]
    #     set_identifier = "mumbai"
    #     latency_region = "ap-south-1"
    #   },
    #   {
    #     name           = "@"
    #     type           = "A"
    #     ttl            = 300
    #     records        = ["18.141.197.30"]
    #     set_identifier = "singapore"
    #     latency_region = "ap-southeast-1"
    #   },
    # For Latency Based Routing

    # For Geolocation Routing
    # India users
    # {
    #   name           = "@"
    #   type           = "A"
    #   ttl            = 300
    #   records        = ["13.203.208.203"]
    #   set_identifier = "india"
    #   geo_location = {country = "IN"}
    # },

    # # Singapore users
    # {
    #   name           = "@"
    #   type           = "A"
    #   ttl            = 300
    #   records        = ["18.141.197.30"]
    #   set_identifier = "singapore"
    #   geo_location = {country = "SG"}
    # },

    # # Default (everyone else)
    # {
    #   name           = "@"
    #   type           = "A"
    #   ttl            = 300
    #   records        = ["3.110.174.241"]
    #   set_identifier = "default"
    #   geo_location   = {country = "*"}
    # },
    # For Geolocation Routing

    # For Failover Routing
    # PRIMARY (Mumbai)
    {
      name            = "@"
      type            = "A"
      ttl             = 300
      records         = ["15.207.111.124"]
      set_identifier  = "primary-mumbai"
      failover_type   = "PRIMARY"
      health_check_id = aws_route53_health_check.primary.id
    },

    # SECONDARY (Singapore)
    {
      name            = "@"
      type            = "A"
      ttl             = 300
      records         = ["3.110.174.241"]
      set_identifier  = "secondary-mumbai"
      failover_type   = "SECONDARY"
      health_check_id = aws_route53_health_check.secondary.id
    },
    # For Failover Routing

    # {
    #   name    = "www"
    #   type    = "A"
    #   ttl     = 300
    #   records = [module.ec2.public_ip] # [aws_instance.web.public_ip] 
    # },
    {
      name    = "@"
      type    = "TXT"
      ttl     = 300
      records = ["v=spf1 include:_spf.google.com ~all"]
    },
    {
      name = "@"
      type = "MX"
      ttl  = 300
      records = [
        "1 ASPMX.L.GOOGLE.COM",
        "5 ALT1.ASPMX.L.GOOGLE.COM",
        "5 ALT2.ASPMX.L.GOOGLE.COM",
        "10 ALT3.ASPMX.L.GOOGLE.COM",
        "10 ALT4.ASPMX.L.GOOGLE.COM"
      ]
    },
    {
      name    = "api"
      type    = "CNAME"
      ttl     = 300
      records = ["backend.example.com"]
    }
  ]

  tags = {
    Client = "client-a"
    Env    = "dev"
  }
}

module "cloudwatch" {
  source = "./modules/Management-and-Governance/cloudwatch"

   providers = {
    aws = aws.use1
  }

  log_group_name     = "/aws/route53/spakcommgroup"
  retention_in_days = 7

  tags = {
    Client = "client-a"
    Env    = "dev"
  }
}

resource "aws_route53_query_log" "this" {
  provider = aws.use1
  zone_id                 = module.route53.zone_id
  cloudwatch_log_group_arn = module.cloudwatch.log_group_arn
}

module "sg" {
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
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 
  ]

  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "ebs" {
  source = "./modules/storage/ebs"
  availability_zone = var.availability_zones[0]
  size              = 20
  name              = "web-dev-data"

  instance_id = module.ec2.instance_id  

  tags = {
    Project     = "tanvora"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

module "ami" {
  source = "./modules/other/image/ami"
  source_instance_id = module.ec2.instance_id
  name               = "tanvora-web-${var.environment}-v1"
  
  tags = {
    Project     = "tanvora"
    Environment = var.environment
    ManagedBy   = "terraform"
    Name = "Tanvora"
  }
}

module "ec2" {
  source             = "./modules/compute/ec2"
  name               = "web-dev"
  # ami_id = var.ami_versions[var.environment] # for version control
  ami_id             =  "ami-02b8269d5e85954ef"
  instance_type      = "t3.small"
  # subnet_id          = module.vpc.public_subnet_ids[0]
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.sg.id]
  key_name           = "master-key-pair"
  iam_instance_profile = module.iam.instance_profile_name
  user_data = file("${path.module}/modules/compute/ec2/web-dev.sh")
  vpc_id = module.vpc.vpc_id

  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
    Project     = "tanvora"
    Environment = "dev"
    Owner       = "ajay"
    ManagedBy   = "terraform"
    CostCenter  = "web"
  }
}

module "elasticip" {
  source = "./modules/network/elasticip"
  name = "web-dev-eip"
  instance_id = module.ec2.instance_id
  tags = {
    Project     = "tanvora"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

module "s3" {
  source        = "./modules/storage/s3"
  bucket_name   = "spakcommgroup-app-dev"
  force_destroy = false
  lifecycle_rules = [
    {
      id              = "logs-archive"
      enabled         = true
      transitions     = [{ days = 30, storage_class = "STANDARD_IA" }]
      expiration_days = 365
    }
  ]
  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "lightsail" {
  source = "./modules/compute/lightsail"

  name              = "web-dev"
  availability_zone = "ap-south-1a"
  bundle_id         = "nano_3_1"
  create_snapshot   = true
  disk_size_gb      = 50

  db_name              = "web-dev-db"
  db_blueprint_id      = "mysql_8_0"
  db_bundle_id         = "micro_2_0"
  master_database_name = var.db_name
  db_master_user       = var.db_username
  db_master_password   = var.db_password

  service_name    = "web-container-dev"
  power           = "micro"
  scale           = 1
  container_image = "nginx:latest"

  tags = {
    Client = "spakcommgroup"
    Env    = "dev"
  }
}

module "rds" {
  source = "./modules/database/rds"

  identifier          = "prod-mysql-db"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  max_allocated_storage = 100
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password

  db_subnet_group_name = module.vpc.db_subnet_group_name
  security_group_ids   = [module.sg.id]
  multi_az = true
  iam_database_authentication_enabled = true
  restore_from_snapshot = false

  restore_from_pitr     = false
  # pitr_restore_time     = "2025-12-20T12:00:00Z"

  tags = {
    Environment = "prod"
    Service     = "database"
  }
}

module "aurora" {
  source = "./modules/database/aurora"

  cluster_identifier = "prod-aurora-mysql"
  instance_class     = "db.r6g.large"
  instance_count     = 2

  database_name = var.db_name
  username      = var.db_username
  password      = var.db_password

  db_subnet_group_name = module.vpc.db_subnet_group_name
  security_group_ids   = [module.sg.id]
  restore_from_snapshot = true

  tags = {
    Environment = "prod"
    Service     = "aurora"
  }
}

module "secret" {
  source = "./modules/security/secret"
  name        = "tanvora/rds/mysql/admin"
  description = "Admin credentials for prod MySQL RDS"

  # for RDS
  secret_value = {
    username             = var.db_username
    password             = var.db_password
    engine               = "mysql"
    host                 = module.rds.rds_endpoint
    port                 = 3306
    dbname               = "appdb"
    dbInstanceIdentifier = module.rds.rds_id
  }

  tags = {
    Environment = "prod"
    Service     = "database"
  }
}

module "kms" {
  source = "./modules/security/kms"

  alias_name = "alias/ecr"
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


module "ecr" {
  source = "./modules/containers/ecr"
  repository_name = "my-app"
  max_images = 5
  kms_key_arn = module.kms.kms_key_arn   # ✅ PASS VALUE
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = "dev"
    Project     = "my-app"
    Owner       = "ajay"
  }
}

module "app_runner" {
  source         = "./modules/compute/app-runner"
  app_name       = "my-app"
  # image_tag      = "latest"
  # container_port = 3000
  ecr_repository_url               = module.ecr.repository_url
  apprunner_ecr_access_role_arn    = module.iam.apprunner_ecr_access_role_arn
  image_tag                        = "v4"
}


module "secret_ecs" {
  source = "./modules/security/secret"
  name        = "tanvora/ecs/app"
  description = "Secrets for ECS Node application"

  # for ecs
  secret_value = {
    DB_PASSWORD = var.db_password
  }

  tags = {
    Environment = "prod"
    Service     = "ecs"
  }
}

module "ecs" {
  source = "./modules/containers/ecs"

  aws_region        = var.aws_region
  cluster_name      = "app-cluster"
  service_name      = "app-service"

  cpu = 256
  memory = 512

  container_image   = module.ecr.repository_url   # SAME ECR USED BY APP RUNNER
  container_port    = 3000

  # subnet_ids        = module.vpc.private_subnet_ids # for production
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_ids = [module.sg.id]
  assign_public_ip = true

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  secret_arn = module.secret_ecs.secret_arn
  ecs_execution_policy_attached_id = module.iam.ecs_execution_policy_attached_id

  desired_count = 1
}
