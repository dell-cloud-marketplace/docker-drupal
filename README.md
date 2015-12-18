# docker-drupal
This image installs [Drupal](https://www.drupal.org/), an open-source content management system.

## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Drupal     | Latest                  | Content Management System
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                  | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language


## Usage

### Start the Container
Start your container binding host port 8080 to container port 80, and 443 in both:

    sudo docker run -d -t -p 8080:80 -p 443:443 -p 3306:3306 dell/drupal
    
You will have to check the container logs, in order to get the MySQL password:

    sudo docker logs <container_id>

You will see some output like the following:

    ====================================================================
    You can now connect to this MySQL Server using:

      mysql -uadmin -pca1w7dUhnIgI -h<host> -P<port>

    =====================================================================

In this case, **ca1w7dUhnIgI** is the password allocated to the admin user. Make a secure note of this value. You can use it later, to connect to MySQL (e.g. to backup data):

    mysql -u admin -pca1w7dUhnIgI -h127.0.0.1 -P3306

### Test your deployment:

You can test your deployment by accessing the Drupal console at:

    http://localhost:8080
    
or with cURL:

    curl http://localhost:8080/
    
Before accessing the Drupal console through HTTPS, which is advisable when maintaining your site, you must accept the SSL certificate.

## Complete the installation
From the Drupal console, log in as user **admin**, password **admin** and start adding content.

## Reference

### Environmental Variables

Variable    | Default  | Description
------------|----------|-----------------------------------
MYSQL_PASS  | *random* | Password for MySQL user **admin**
DRUPAL_PASS | *random* | Password for MySQL user **drupal**
ADMIN_PASS  | *random* | Password for Drupal user **admin**

### Image Details

Based on          | [docker-drupal](https://github.com/ricardoamaro/docker-drupal.git)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/drupal](https://registry.hub.docker.com/u/dell/drupal)



