#!/bin/bash
touch /var/log/user_data.log
exec > /var/log/user_data.log 2>&1
set -ex

DB_NAME="${DB_NAME}"
DB_USER="${DB_USER}"
DB_PASSWORD="${DB_PASSWORD}"

echo "Starting system update..."
apt update -y && apt upgrade -y
echo "System update complete."

echo "Installing Docker..."
apt install -y docker.io
systemctl start docker
systemctl enable docker

echo "Running MySQL container..."
docker run --name mysql -e MYSQL_ROOT_PASSWORD=${DB_PASSWORD} -e MYSQL_DATABASE=${DB_NAME} -e MYSQL_USER=${DB_USER} -e MYSQL_PASSWORD=${DB_PASSWORD} -d mysql:5.7

echo "Running WordPress container..."
docker run --name wordpress --link mysql:mysql -p 80:80 -e WORDPRESS_DB_HOST=mysql:3306 -e WORDPRESS_DB_NAME=${DB_NAME} -e WORDPRESS_DB_USER=${DB_USER} -e WORDPRESS_DB_PASSWORD=${DB_PASSWORD} -d wordpress

echo "Setup complete."