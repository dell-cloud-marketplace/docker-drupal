# docker-drupal
This blueprint installs a [Docker](http://docker.io) container for [Drupal](https://www.drupal.org/) – an open source content management platform that uses a range of technologies as part of its framework to build web sites.

## Components
The stack comprises the following components (some are obtained through [dell/lamp-base](https://registry.hub.docker.com/u/dell/lamp-base)):

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Drupal     | Latest                  | Content Management System
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                  | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language


## Usage

### Start the Container
Start your image binding host port 8080 to port 80 (Apache Web Server) and 443:443 (HTTPS port) in your container:

    docker run -d -t -p 8080:80 -p 443:443 -p 3306:3306 dell/drupal
    
You will have to check the container logs, in order to get the MySQL root and drupal password:

    docker logs <container_id>

You will see an output like the following:

    mysql root password: phahP5utee7x
    drupal password: AhsaiNg8eiyu

root and drupal users are not granted to access MySQL from outside the container.
Therefore, in order to access MySQL with root and drupal users, log in to the container by issuing those 2 commands:

    docker inspect --format '{{.State.Pid}}' <container_id>
    This command gives you a target number. Then access the container by:
    nsenter --target <target_number> --mount --uts --ipc --net --pid

From the container, you can now access MySQL with root/drupal credentials with:

    mysql -uroot -p<root_password>
    mysql -udrupal -p<drupal_password>

You can also access MySQL from outside (the VM where you run the container for example) by using admin credentials that you can find in container logs such as displayed below:

    ====================================================================
    You can now connect to this MySQL Server using:

      mongo admin -u admin -pca1w7dUhnIgI --host <host> --port <port>

    =====================================================================

In this case, **ca1w7dUhnIgI** is the password allocated to the admin user. Make a secure note of this value. You can use it later, to connect to MySQL (e.g. to backup data):

    mysql -u admin -pca1w7dUhnIgI -h127.0.0.1 -P3306

### Test your deployment:

You can test your deployment by accessing Drupal console at:

    http://localhost:8080
    
 or
 
    https://localhost
    
Before accessing the Drupal console through HTTPS, you must accept the SSL certificate.

You can also test the application with cURL command:

    curl http://localhost:8080/


## Complete the installation
From the Drupal console, log in with admin/admin and start adding content.


### Image Details

Based on          | [Ricardo Amaro](https://github.com/ricardoamaro/docker-drupal.git)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/drupal](https://registry.hub.docker.com/u/dell/drupal)




