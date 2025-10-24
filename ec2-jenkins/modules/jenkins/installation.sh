#!/bin/bash
# Update system
yum update -y

# Install Java (required for Jenkins)
amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repo and key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
yum install jenkins -y

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins
