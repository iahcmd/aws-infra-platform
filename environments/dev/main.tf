# ──────────────────────────────────────────────────────────────
# Development Environment Root Module
# ──────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "iahcmd-terraform-state"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "iahcmd-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = "10.0.0.0/16"
  availability_zones    = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24"]
  isolated_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]
  enable_nat_gateway    = true
  single_nat_gateway    = true
}

module "s3" {
  source = "../../modules/s3"

  project_name       = var.project_name
  environment        = var.environment
  bucket_purpose     = "assets"
  versioning_enabled = false
  enable_lifecycle   = true
  expiration_days    = 90
}

module "iam" {
  source = "../../modules/iam"

  project_name  = var.project_name
  environment   = var.environment
  s3_bucket_arn = module.s3.bucket_arn
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_port          = var.app_port
  health_check_path = "/healthz"
}

module "rds" {
  source = "../../modules/rds"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  isolated_subnet_ids = module.vpc.isolated_subnet_ids
  allowed_security_group_ids = [
    module.ecs.service_security_group_id
  ]

  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  database_name           = "appdb_dev"
  database_username       = "dbadmin"
  database_password       = var.database_password
  multi_az                = false
  backup_retention_period = 1
  deletion_protection     = false
}

module "elasticache" {
  source = "../../modules/elasticache"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_security_group_ids = [
    module.ecs.service_security_group_id
  ]

  node_type           = "cache.t4g.micro"
  num_cache_nodes     = 1
  automatic_failover  = false
}

module "ecs" {
  source = "../../modules/ecs"

  project_name        = var.project_name
  environment         = var.environment
  region              = var.region
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
  execution_role_arn  = module.iam.execution_role_arn
  task_role_arn       = module.iam.task_role_arn

  container_image = var.container_image
  container_port  = var.app_port
  cpu             = 256
  memory          = 512
  desired_count   = 2
  min_capacity    = 1
  max_capacity    = 4
}
