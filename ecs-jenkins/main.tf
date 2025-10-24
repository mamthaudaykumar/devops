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
