module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "ec2-jenkins" {
  source               = "./modules/ec2-jenkins"
  ec2_ami_id_jenkins             = var.ec2_ami_id_jenkins
  instance_type_jenkins             = var.instance_type_jenkins
  ec2_name_jenkins   = var.ec2_name_jenkins
  subnet_id     = module.networking.dev_proj_public_subnets[0]
}
