provider "aws" {
  region = "eu-west-2"
}

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "networking" {
  source = "../ecs-jenkins/networking"
  project_prefix = var.project_prefix
  eu_availability_zone = var.eu_availability_zone
  cidr_public_subnet = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
  vpc_cidr = var.vpc_cidr
}

module "iam" {
  source = "../ecs-jenkins/iam"
  project_prefix = var.project_prefix
}

module "ecs" {
  source = "../ecs-jenkins/ecs" 
  project_prefix = var.project_prefix
  public_subnet_id = module.networking.public_subnet_ids[0]
  iam_instance_profile_name = module.iam.ecs_instance_profile_name
  vpc_id = module.networking.vpc_id
}
