#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

#install Jenkins 
apt-get update
add-apt-repository ppa:linuxuprising/java -y
 apt-get update -y
 # Install Java
 echo oracle-java11-installer shared/accepted-oracle-licence-v1-2 boolean true | sudo /usr/bin/debconf-set-selections
 apt-get install oracle-java11-installer -y

apt-get install oracle-java11-set-default -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
apt-get update
sudo apt-get install jenkins -y

# start Jenkins Service
sudo service jenkins start
sudo echo "***** Admin Password ******"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo echo "***** Admin Password ******"

# install nginx
apt-get update
apt-get -y install nginx

# make sure nginx is started
service nginx start
