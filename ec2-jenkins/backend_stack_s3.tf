terraform {
  backend "s3" {
    bucket = "dev-proj-s3-statefile-ec2"
    key    = "devops-project/jenkins/terraform.tfstate"
    region = "eu-west-2"
  }
}