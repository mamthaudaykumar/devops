#!/bin/bash
set -ex

LOGFILE="/var/log/jenkins-user-data.log"
echo "Starting Jenkins installation..." >> $LOGFILE

# Update system
apt update -y >> $LOGFILE 2>&1
apt upgrade -y >> $LOGFILE 2>&1

# Install Java 17 and required tools
apt install -y openjdk-17-jdk wget gnupg2 curl >> $LOGFILE 2>&1

# Verify Java
java -version >> $LOGFILE 2>&1

# Add Jenkins GPG key and repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index
apt update -y >> $LOGFILE 2>&1

# Install Jenkins
apt install -y jenkins >> $LOGFILE 2>&1

# Fix permissions
chown -R jenkins:jenkins /var/lib/jenkins
chown -R jenkins:jenkins /var/cache/jenkins

# Enable and start Jenkins
systemctl daemon-reload >> $LOGFILE 2>&1
systemctl enable jenkins >> $LOGFILE 2>&1
systemctl start jenkins >> $LOGFILE 2>&1

# Verify Jenkins is running
systemctl status jenkins >> $LOGFILE 2>&1

echo "Jenkins installation completed successfully." >> $LOGFILE
