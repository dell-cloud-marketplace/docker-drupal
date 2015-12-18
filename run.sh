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

    # If not supplied, generate a random password for the drupal MySQL user.
    DRUPAL_PASSWORD=${DRUPAL_PASS:-$(pwgen -s 12 1)}

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

    # If not supplied, generate a random password for the admin user.
    ADMIN_PASSWORD=${ADMIN_PASS:-$(pwgen -s 12 1)}

    echo
    echo "========================================================================"
    echo
    echo "Drupal admin user password:" $ADMIN_PASSWORD
    echo
    echo "========================================================================"

    # Install Drupal
    cd /var/www/html
    drush site-install standard -y --account-name=admin --account-pass=$ADMIN_PASSWORD \
            --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal"
    
    mysqladmin -uroot shutdown
    sleep 5
fi

exec supervisord -n
