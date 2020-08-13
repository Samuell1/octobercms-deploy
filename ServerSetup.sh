#!/bin/bash

apt update

# Install dependencies
apt install wget
apt-add-repository ppa:ondrej/php
apt update
apt install -y php7.3
apt install -y php7.3-fpm
apt install -y php-cgi php-mbstring php-xml php-zip php-mysql php-gd php-xml php-curl php-imap
apt install -y nginx software-properties-common python-pip
apt install -y npm

# Queue worker
apt install -y supervisor

# Get basic details of the running instance
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`"
EC2_ZONE="`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone`"
EC2_REGION="`echo $EC2_ZONE | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

# Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php -- --install-dir=/usr/bin --filename=composer
rm composer-setup.php

# Speed up composer install with parallel downloading
composer global require hirak/prestissimo

# Ruby for codedeploy agent
apt install -y ruby

# Install AWS codedeploy agent
wget https://aws-codedeploy-${EC2_REGION}.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
service codedeploy-agent start
rm -rf install

# Restart php and nginx
service php7.3-fpm reload
service nginx reload
