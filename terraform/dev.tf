locals {
  project_name = "eli"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azs      = var.availability_zones
  prefix   = "${local.project_name}-${var.environment}"
}
