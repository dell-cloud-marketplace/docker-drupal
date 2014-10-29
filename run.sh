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
 
# Install Drupal
if [ ! -f /var/www/html/sites/default/settings.php ]; then

    # Start MySQL
    /usr/bin/mysqld_safe > /dev/null 2>&1 &

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup"
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    DRUPAL_DB="drupal"

    # Generate a random password for the drupal MySQL user.
    DRUPAL_PASSWORD=`pwgen -c -n -1 12`

    echo "========================================================================"
    echo
    echo "MySQL drupal user password:" $DRUPAL_PASSWORD
    echo
    echo "========================================================================"

    # Create the database
    mysql -uroot -e "CREATE DATABASE drupal; \
            GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' \
            IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"

    # Update permissions.
    sed -i 's/AllowOverride None/AllowOverride All/g' \
            /etc/apache2/sites-available/000-default.conf
    sed -i 's/AllowOverride Limit/AllowOverride All/g' \
            /etc/apache2/sites-available/000-default.conf

    # Install Drupal
    cd /var/www/html
    drush site-install standard -y --account-name=admin --account-pass=admin \
            --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal"
    
    mysqladmin -uroot shutdown
    sleep 5
fi

exec supervisord -n
