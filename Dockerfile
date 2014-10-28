# docker Drupal
#
# VERSION       1
# DOCKER-VERSION        1
FROM  debian:wheezy
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

#RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main restricted universe multiverse" > /etc/apt/sources.list
RUN apt-get update
#RUN apt-get -y upgrade

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl  
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git mysql-client=5.5.40-0+wheezy1
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git mysql-client=5.5.40-0+wheezy1
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server=5.5.40-0+wheezy1
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2=2.2.22-13+deb7u3
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5=5.4.4-14+deb7u14
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql=5.4.4-14+deb7u14 php5-curl=5.4.4-14+deb7u14
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen python-setuptools vim-tiny  php-apc php5-gd php5-memcache memcached drush mc
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean

# Make mysql listen on the outside
RUN sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf

RUN easy_install supervisor
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf

#Configure SSL
#---Activate the SSL Module
RUN a2enmod ssl
RUN service apache2 restart
#---Create the SSL Dir
RUN mkdir /etc/apache2/ssl
#---Create Self-Signed SSL Certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj '/O=Dell/OU=MarketPlace/CN=www.dell.com'
#---Copy the config file that uses the new SSL key pairs
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl
#---Activate the new virtual host
RUN a2ensite default-ssl
RUN service apache2 restart



# Retrieve drupal
RUN rm -rf /var/www/ ; cd /var ; drush dl drupal ; mv /var/drupal*/ /var/www/
RUN chmod a+w /var/www/sites/default ; mkdir /var/www/sites/default/files ; chown -R www-data:www-data /var/www/

RUN chmod 755 /start.sh /etc/apache2/foreground.sh



EXPOSE 80 443
CMD ["/bin/bash", "/start.sh"]
