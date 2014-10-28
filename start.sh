#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
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
	# Generate random passwords 
	DRUPAL_DB="drupal"
	MYSQL_PASSWORD=`pwgen -c -n -1 12`
	DRUPAL_PASSWORD=`pwgen -c -n -1 12`
	# This is so the passwords show up in logs. 
	echo mysql root password: $MYSQL_PASSWORD
	echo drupal password: $DRUPAL_PASSWORD
	echo $MYSQL_PASSWORD > /mysql-root-pw.txt
	echo $DRUPAL_PASSWORD > /drupal-db-pw.txt
	mysqladmin -u root password $MYSQL_PASSWORD 
	mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"
	sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/000-default.conf
	a2enmod rewrite vhost_alias
	cd /var/www/
	drush site-install standard -y --account-name=admin --account-pass=admin --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal"
	killall mysqld
	sleep 10s
fi
supervisord -n
