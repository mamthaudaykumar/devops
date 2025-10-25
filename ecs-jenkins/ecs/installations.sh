#!/bin/bash
set -e

# Update system and install dependencies
sudo yum update -y
sudo yum install -y unzip curl git

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip ./aws

# Verify AWS CLI
aws --version

# Install Docker
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
docker --version

# Create persistent Jenkins home
sudo mkdir -p /ecs/jenkins_home
sudo chown -R ec2-user:ec2-user /ecs/jenkins_home

# Pull Jenkins images
sudo docker pull --platform linux/amd64 jenkins/jenkins:lts

# Authenticate Docker to ECR
aws ecr get-login-password --region eu-west-2 | sudo docker login \
  --username AWS --password-stdin 536898554061.dkr.ecr.eu-west-2.amazonaws.com

# Pull Jenkins image from ECR
sudo docker pull 536898554061.dkr.ecr.eu-west-2.amazonaws.com/jenkins:latest

# Remove existing Jenkins container if exists
if [ "$(sudo docker ps -a -q -f name=jenkins)" ]; then
    sudo docker stop jenkins || true
    sudo docker rm jenkins || true
fi

# Run Jenkins container
sudo docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 -p 50000:50000 \
  536898554061.dkr.ecr.eu-west-2.amazonaws.com/jenkins:latest
