variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID for your region"
  default     = "ami-0c02fb55956c7d316" # Example for us-east-1
}

variable "key_name" {
  description = "Your existing EC2 key pair name"
}
