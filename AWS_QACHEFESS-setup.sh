#!/bin/bash

# Add user 'chef', password 'chef'
useradd chef
echo chef | passwd chef --stdin

# Config sudo access.
echo "chef    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i 's/Defaults.*requiretty/#Defaults requiretty/g' /etc/sudoers

# Allow password access via ssh
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart

# Flush & Disable iptables
# Could not see iptables enabled by default on Centos 7. Need to confirm
iptables -F
service iptables stop
chkconfig iptables off

# Disable SELinux
setenforce 0
#ignore the error if this produces one
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# Set the MOTD
curl https://s3.amazonaws.com/uploads.hipchat.com/7557/343581/8r8bE9vCpEW87E8/getawesome.txt > /etc/motd
#disable the update to the motd
sudo /usr/sbin/update-motd --disable

# Update image
yum update -y

#Download chefdk installer
curl https://packages.chef.io/files/stable/chefdk/1.1.16/el/7/chefdk-1.1.16-1.el7.x86_64.rpm -o chefdk-1.1.16-1.el7.x86_64.rpm

#lets install chefdk
rpm -Uvh chefdk-1.1.16-1.el7.x86_64.rpm

# Configure docker repo for Centos 7
#curl -O http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-6.noarch.rpm
#rpm -ivh epel-release-7-6.noarch.rpm
#yum -y remove docker
#yum install -y docker-io

sudo yum install -y docker
chkconfig docker on
service docker start

# Install editors
yum install -y vim nano emacs

# Ohai hints
mkdir -p /etc/chef/ohai/hints
echo '{}' > /etc/chef/ohai/hints/ec2.json

#add ruby to the path
sed -i "s/export PATH/ /g" /home/chef/.bash_profile
echo "PATH=\$PATH:\$HOME/.local/bin:\$HOME/bin:/home/chef/.chefdk/gem/ruby/2.3.0/bin" >> /home/chef/.bash_profile
echo "export PATH" >> /home/chef/.bash_profile

# Make sure that docker plugin installed into kitchen - ignore the error, is added to path
su chef -c "/opt/chefdk/embedded/bin/gem install kitchen-docker"

# remove files
rm -f chefdk-1.1.16-1.el7.x86_64.rpm


# And we are done
echo '######## All Done! ######'
