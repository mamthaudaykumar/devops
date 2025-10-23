terraform {
  backend "s3" {
    bucket = "dev-proj-s3-statefile"
    key    = "devops-project/jenkins/terraform.tfstate"
    region = "eu-west-2"
  }
}