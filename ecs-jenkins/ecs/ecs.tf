variable "project_prefix" {}
variable "public_subnet_id" {}
variable "iam_instance_profile_name" {}
variable "vpc_id" {}
variable "key_pair_name" {}

# Optional variables for security group names
variable "ec2_sg_name" {
  default = "ecs-ssh-http-sg"
}
variable "ec2_jenkins_sg_name" {
  default = "ecs-jenkins-8080-sg"
}

# Get Amazon Linux ECS optimized AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# ECS Security Group (SSH + Jenkins)
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_prefix}-ecs-sg"
  description = "ECS security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-ecs-sg"
  }
}

# Optional: Separate SG for Jenkins HTTP if needed
resource "aws_security_group" "ec2_jenkins_port_8080" {
  name        = var.ec2_jenkins_sg_name
  description = "Enable port 8080 for Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-jenkins-8080-sg"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "jenkins_cluster" {
  name = "${var.project_prefix}-jenkins-cluster"
}

# Launch Template
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.project_prefix}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = base64encode(<<EOF
    #!/bin/bash
    # Register instance with ECS cluster
    echo "ECS_CLUSTER=${aws_ecs_cluster.jenkins_cluster.name}" >> /etc/ecs/ecs.config

    # Update system and install dependencies
    yum update -y
    yum install -y wget yum-utils

    # Install Java 11
    amazon-linux-extras enable corretto11
    yum install -y java-11-amazon-corretto

    # Add Jenkins repo
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    # Install Jenkins
    yum clean all
    yum install -y jenkins

    # Enable and start Jenkins service
    systemctl daemon-reload
    systemctl enable jenkins
    systemctl start jenkins
    EOF
    )


  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.public_subnet_id
    security_groups = [
      aws_security_group.ecs_sg.id,
      aws_security_group.ec2_jenkins_port_8080.id
    ]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_prefix}-ecs-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.public_subnet_id]

  force_delete = true
  lifecycle {
    create_before_destroy = true
  }

  wait_for_capacity_timeout = "10m"
}
