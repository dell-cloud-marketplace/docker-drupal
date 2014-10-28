#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

# Possibly invoke the inherited script to create the admin user.
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

if [ ! -f /var/www/sites/default/settings.php ]; then

    # Start mysql
    /usr/bin/mysqld_safe & 
    sleep 10s

    DRUPAL_DB="drupal"

    # Generate random passwords
    MYSQL_PASSWORD=`pwgen -c -n -1 12`
    DRUPAL_PASSWORD=`pwgen -c -n -1 12`

    # The passwords will show up in the logs. 
    echo "MySQL root user password:" $MYSQL_PASSWORD
    echo "MySQL drupal user password:" $DRUPAL_PASSWORD
    echo $MYSQL_PASSWORD > /mysql-root-pw.txt
    echo $DRUPAL_PASSWORD > /drupal-db-pw.txt

    # Set the root user password
    mysqladmin -u root password $MYSQL_PASSWORD 

    # Create the database
    mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE drupal; \
            GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' \
            IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"

    # Update permissions.
    sed -i 's/AllowOverride None/AllowOverride All/g' \
            /etc/apache2/sites-available/000-default.conf
    sed -i 's/AllowOverride Limit/AllowOverride All/g' \
            /etc/apache2/sites-available/000-default.conf

    a2enmod rewrite vhost_alias

    # Install Drupal
    cd /var/www/
    drush site-install standard -y --account-name=admin --account-pass=admin \
            --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal"
    
    killall mysqld
    sleep 10s
fi

supervisord -n
