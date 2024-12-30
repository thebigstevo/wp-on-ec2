            #!/bin/bash
            touch /var/log/user_data.log
            exec > /var/log/user_data.log 2>&1
            set -ex

            echo "Starting system update..."
            apt update -y
            echo "System update complete."

            echo "Installing Apache, PHP, and MySQL client..."
            apt install apache2 php mysql-client php-mysql unzip wget -y
            systemctl start apache2
            systemctl enable apache2

            echo "Downloading and setting up WordPress..."
            cd /var/www/html
            wget https://wordpress.org/latest.zip
            unzip latest.zip
            mv wordpress/* .
            rm -rf wordpress latest.zip
            chown -R www-data:www-data /var/www/html/
            chmod -R 755 /var/www/html
            systemctl restart apache2

            # Install MySQL server
            echo "Installing MySQL server..."
            apt install mysql-server -y
            systemctl start mysql
            systemctl enable mysql

            # Create WordPress database and user
            mysql -u root -e "CREATE DATABASE wordpress;"
            mysql -u root -e "CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'yourpassword';"
            mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'localhost';"
            mysql -u root -e "FLUSH PRIVILEGES;"

            #configure WordPress
            # Create the wp-config.php file from the sample
            cp wp-config-sample.php wp-config.php

            # Set database details
            sed -i "s/database_name_here/wordpress/" wp-config.php
            sed -i "s/username_here/wordpress_user/" wp-config.php
            sed -i "s/password_here/yourpassword/" wp-config.php

            # Ensure proper permissions
            chown -R www-data:www-data /var/www/html
            chmod -R 755 /var/www/html

            # Restart Apache to apply changes
            systemctl restart apache2
            echo "Setup complete."