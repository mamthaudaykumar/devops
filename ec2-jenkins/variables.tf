variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "ec2_ami_id_jenkins" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type_jenkins" {
  description = "The type of EC2 instance to launch (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "ec2_name_jenkins" {
  description = "The Name tag for the EC2 instance"
  type        = string
  default     = "devops-ec2-instance"
}
