variable "ec2_ami_id_jenkins" {}
variable "instance_type_jenkins" {}
variable "ec2_name_jenkins" {}
variable "subnet_id" {}
variable "security_group_id" {
}
variable "keyssh" {}
variable "security_group_id_8080" {}


resource "aws_instance" "dev-proj-ec2-jenkins" {
  ami           = var.ec2_ami_id_jenkins
  instance_type = var.instance_type_jenkins
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id, var.security_group_id_8080]
  associate_public_ip_address = true
  key_name      = var.keyssh


  user_data = file("${path.module}/install_jenkins.sh")

  tags = {
    Name = var.ec2_name_jenkins
  }
}
