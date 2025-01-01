#!/bin/bash
touch /var/log/user_data.log
exec > /var/log/user_data.log 2>&1
set -ex

DB_NAME="wordpress"
DB_USER="wordpress_user"
DB_PASSWORD="${database_password}"

echo "Starting system update..."
apt update -y && apt upgrade -y
echo "System update complete."

echo "Installing Apache, PHP, and MySQL server..."
apt install -y apache2 php mysql-server php-mysql unzip wget
systemctl start apache2
systemctl enable apache2

echo "Downloading and setting up WordPress..."
cd /var/www/html
rm -rf *  # Ensure no default files remain
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* .
rm -rf wordpress latest.zip

# Configure Apache for WordPress
echo "Configuring Apache for WordPress..."
cat <<EOT > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOT

# Disable default site and enable WordPress site
a2dissite 000-default.conf
a2ensite wordpress.conf
a2enmod rewrite
systemctl reload apache2

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting MySQL server..."
systemctl start mysql
systemctl enable mysql

# Create WordPress database and user
mysql -u root <<EOF
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Configuring WordPress..."
cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" wp-config.php

# Restart Apache to apply changes
systemctl restart apache2
echo "Setup complete."