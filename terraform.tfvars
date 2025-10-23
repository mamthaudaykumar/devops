bucket_name = "dev-proj-s3-statefile"

vpc_cidr             = "12.0.0.0/16"
vpc_name             = "dev-proj-jenkins-eu-west-2_vpc"
cidr_public_subnet   = ["12.0.1.0/24", "12.0.2.0/24"]
cidr_private_subnet  = ["12.0.3.0/24", "12.0.4.0/24"]
eu_availability_zone = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
ec2_ami_id_jenkins    = "ami-06b6e5258935d111e"
instance_type_jenkins = "t3.micro"
ec2_name_jenkins     = "ec2-dev-proj-jenkins"