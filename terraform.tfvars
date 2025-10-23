bucket_name = "dev-proj-s3-statefile"

vpc_cidr             = "12.0.0.0/16"
vpc_name             = "dev-proj-jenkins-eu-west-2_vpc"
cidr_public_subnet   = ["12.0.1.0/24", "12.0.2.0/24"]
cidr_private_subnet  = ["12.0.3.0/24", "12.0.4.0/24"]
eu_availability_zone = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

# public_key = ""
# ec2_ami_id = "ami-0694d931cee176e7d"