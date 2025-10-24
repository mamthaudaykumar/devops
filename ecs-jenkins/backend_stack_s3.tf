terraform {
  backend "s3" {
    bucket = "dev-proj-s3-statefile-ecs"
    key    = "devops-project/terraform.tfstate"
    region = "eu-west-2"
  }
}