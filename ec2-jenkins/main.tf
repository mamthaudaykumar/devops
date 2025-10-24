module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "securitygroup" {
  source              = "./modules/security-group"
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  vpc_id              = module.networking.dev_proj_vpc_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

# Generate a new SSH private key
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS
resource "aws_key_pair" "dev_proj_jenkins_key" {
  key_name   = "dev_proj_jenkins_key"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

module "ec2-jenkins" {
  source               = "./modules/ec2-jenkins"
  ec2_ami_id_jenkins             = var.ec2_ami_id_jenkins
  instance_type_jenkins             = var.instance_type_jenkins
  ec2_name_jenkins   = var.ec2_name_jenkins
  subnet_id     = module.networking.dev_proj_public_subnets[0]
  security_group_id     = module.securitygroup.sg_ec2_sg_ssh_http_id
  keyssh      = aws_key_pair.dev_proj_jenkins_key.key_name
}
