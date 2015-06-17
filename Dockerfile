FROM dell/lamp-base:1.2
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Update existing packages.
RUN apt-get update 

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        php5-gd \
        php5-memcache \
        memcached \
        drush \
        mc
RUN apt-get -y clean

# Add scripts
COPY ./run.sh /run.sh
RUN chmod +x /run.sh

# Retrieve Drupal and configure the site folder.
RUN rm -rf /var/www/html; cd /var; drush dl drupal; \
    mv /var/drupal*/ /var/www/html

RUN chmod a+w /var/www/html/sites/default; \
    mkdir /var/www/html/sites/default/files; \
    chown -R www-data:www-data /var/www/html

# Environmental variables.
ENV DRUPAL_PASS ""
ENV ADMIN_PASS ""

EXPOSE 80 443 3306

CMD ["/run.sh"]
