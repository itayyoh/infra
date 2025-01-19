# environments/prod/main.tf

provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

locals {
  environment = "prod-shorturl-itay"
  mandatory_tags = {
    Owner = "itay-yohanok"
    Bootcamp = "BC22"
    Expiration_date = "30-03-2025"
  }
}

# VPC and Networking
module "networking" {
  source = "../../modules/networking"

  environment = local.environment
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  tags = local.mandatory_tags
}

# Security (IAM and Security Groups)
module "security" {
  source = "../../modules/security"

  environment = local.environment
  vpc_id = module.networking.vpc_id
  tags = local.mandatory_tags
}

# EKS Cluster and Node Group
module "eks" {
  source = "../../modules/eks"

  environment = local.environment
  kubernetes_version = var.kubernetes_version
  cluster_role_arn = module.security.cluster_role_arn
  node_role_arn = module.security.node_role_arn
  subnet_ids = module.networking.private_subnet_ids
  cluster_security_group_id = module.security.cluster_security_group_id
  tags = local.mandatory_tags

  depends_on = [
    module.networking,
    module.security
  ]
}