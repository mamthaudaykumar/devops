variable "project_prefix" {}
variable "ecs_pubic_subnet" {}

resource "aws_ecs_cluster" "jenkins_cluster" {
  name = "${var.project_prefix}-jenkins-cluster"
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.project_prefix}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.jenkins_cluster.name}" >> /etc/ecs/ecs.config
EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.ecs_pubic_subnet
    security_groups             = [aws_security_group.ecs_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_prefix}-ecs-jenkins-instance"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.ecs_pubic_subnet]
}
