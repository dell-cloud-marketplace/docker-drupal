FROM dell/lamp-base:1.0 
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-memcache 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install memcached 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install drush 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mc

# Add scripts
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

# Retrieve Drupal and configure the site folder.
RUN rm -rf /var/www/html; cd /var; drush dl drupal; \
    mv /var/drupal*/ /var/www/html

RUN chmod a+w /var/www/html/sites/default; \
    mkdir /var/www/html/sites/default/files; \
    chown -R www-data:www-data /var/www/html

EXPOSE 80 443 3306

CMD ["/run.sh"]
