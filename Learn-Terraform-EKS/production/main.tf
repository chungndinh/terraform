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

module "eks" {
  source = "../modules/eks"
  eks_cluster_version  = "1.27"
  instance_types = ["t3.small"]
  desired_size = 1
  max_size = 1
  min_size = 1
  max_unavailable = 1
  subnet_private_1a = module.networking.subnet_private_1a
  subnet_private_1b = module.networking.subnet_private_1b
  subnet_public_1a = module.networking.subnet_public_1a
  subnet_public_1b = module.networking.subnet_public_1b
  project = var.project
  env = var.env
}
resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl"
    }
    provisioner "local-exec" {
        command = "aws eks --region ap-southeast-1 update-kubeconfig --name ${var.project}-${var.env}-EKS-Cluster"
    }
    provisioner "local-exec" {
        command = "./kubectl apply -f ../eks/*.yaml"
    }
 depends_on = [
    module.eks
  ]    
}


## 
data "aws_lb" "selected" {
  tags = {
    "Namespace-Service" = "Staging-Echoserver"
  } 
  depends_on = [
      resource.null_resource.kubectl
    ]      
}  


data "aws_lb_listener" "lb" {
  port = 8080
  load_balancer_arn = "${data.aws_lb.selected.arn}"  
}





## Module API Gateway
module "api-gw" {
  aws_lb_listener_id = data.aws_lb_listener.lb.id
  source = "../modules/api-gw"
  vpc_id = module.networking.vpc_id
  subnet_private_1a = module.networking.subnet_private_1a
  subnet_private_1b = module.networking.subnet_private_1b
  depends_on = [
      data.aws_lb_listener.lb
    ]      
}
output "hello_base_url" {
  value = module.api-gw.hello_base_url
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "eip" {
  value = module.networking.eip
}
output "lb" {
  value = data.aws_lb_listener.lb.id
}