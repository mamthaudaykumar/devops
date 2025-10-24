variable "project_prefix" {
  default = "test"
  type = string
  description = "Prefix for all the resources"
}

variable "eu_availability_zone" {
  default = ["eu-west-1a"]
  type = list(string)
  description = "Availaility Zone"
}

variable "cidr_public_subnet" {
  default = ["12.0.1.0/24", "12.0.2.0/24"]
  type = list(string)
  description = "Availaility Zone"
}

variable "cidr_private_subnet" {
   default = ["12.0.3.0/24", "12.0.4.0/24"]
  type = list(string)
  description = "Availaility Zone"
}
variable "vpc_cidr" {
  default = "12.0.0.0/16"
  type = string
}