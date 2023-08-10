terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.74.2"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
  # profile = "chungndinh"
}
module "networking" {
  source = "../modules/networking"
  env = var.env
  project = var.project
  vpc_cidr = var.vpc_cidr
}

# module "eks" {
#   source = "../modules/eks"
#   eks_cluster_name     = "${var.project}_cluster"
#   eks_cluster_version  = "1.24"
#   node_group_name = "${var.project}_node_group"
#   instance_types = ["t3.small"]
#   desired_size = 1
#   max_size = 1
#   min_size = 1
#   max_unavailable = 1
#   subnet_private_1a = module.networking.subnet_private_1a
#   subnet_private_1b = module.networking.subnet_private_1b
#   subnet_public_1a = module.networking.subnet_public_1a
#   subnet_public_1b = module.networking.subnet_public_1b
# }
output "vpc_id" {
  value = module.networking.vpc_id

}
output "eip" {
  value = module.networking.eip
}

# module "api_gw_integration" {
#   source = "./modules/api-gw-integration"
#   subnet_private_1a = module.networking.subnet_private_1a
#   subnet_private_1b = module.networking.subnet_private_1b
#   subnet_public_1a = module.networking.subnet_public_1a
#   subnet_public_1b = module.networking.subnet_public_1b
#   vpc_id = module.networking.vpc_id
# }

/* module "autoscaling" {
  source = "./modules/autoscaling"
} */