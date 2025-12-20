#!/bin/bash
# install_nginx.sh

set -e

sudo apt update
sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

echo "Hello World" | sudo tee /var/www/html/index.html

echo "NGINX installed and running. Open: http://<EC2_PUBLIC_IP>"
