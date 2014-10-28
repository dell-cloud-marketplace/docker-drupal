FROM dell/lamp-base:1.0 
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-setuptools 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install vim-tiny 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-memcache 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install memcached 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install drush 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mc

RUN easy_install supervisor
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf

#Replace /var/www/html to /var/www/
RUN sed -i "s/\/var\/www\/html/\/var\/www/g" /etc/apache2/sites-available/000-default.conf

# Retrieve drupal
RUN rm -rf /var/www/ ; cd /var ; drush dl drupal ; mv /var/drupal*/ /var/www/
RUN chmod a+w /var/www/sites/default ; mkdir /var/www/sites/default/files ; chown -R www-data:www-data /var/www/

RUN chmod 755 /start.sh /etc/apache2/foreground.sh

EXPOSE 80 443 3306
CMD ["/bin/bash", "/start.sh"]
