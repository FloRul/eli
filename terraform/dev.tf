locals {
  project_name = "eli"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azs      = var.availability_zones
  prefix   = "${local.project_name}-${var.environment}"
}

module "rds" {
  source              = "./modules/rds"
  prefix                = "${local.project_name}-${var.environment}"
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.db_subnet_group_name
  private_subnet_cidrs = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i)]
  
  # RDS configuration
  allocated_storage   = 20
  engine_version      = "17.4"
  instance_class      = "db.t3.micro"
  db_name             = "elidb"
  db_username         = "eliuser"
}

