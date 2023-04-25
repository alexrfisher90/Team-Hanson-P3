#!/bin/bash
yum update -y
yum install git -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
git clone https://github.com/alexrfisher90/Team-Hanson-P3/ ./var/www/html
mv -v /var/www/html/Snakes/* /var/www/html/
rm -rf /var/www/html/Snakes/