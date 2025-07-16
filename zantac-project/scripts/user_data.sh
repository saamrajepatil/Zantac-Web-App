#!/bin/bash
yum update -y
yum install -y httpd
sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
systemctl enable httpd
systemctl start httpd
echo "<h1>Hello from zantac app deployed using Terraform</h1>" > /var/www/html/index.html