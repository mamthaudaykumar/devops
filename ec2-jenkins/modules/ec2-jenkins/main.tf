variable "ec2_ami_id_jenkins" {}
variable "instance_type_jenkins" {}
variable "ec2_name_jenkins" {}
variable "subnet_id" {}
variable "security_group_id" {
  
}


resource "aws_instance" "dev-proj-ec2-jenkins" {
  ami           = var.ec2_ami_id_jenkins
  instance_type = var.instance_type_jenkins
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = var.ec2_name_jenkins
  }
}
