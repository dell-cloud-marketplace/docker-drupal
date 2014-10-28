# docker-drupal
This blueprint installs a [Docker](http://docker.io) container for [Drupal](https://www.drupal.org/) – an open source content management platform that uses a range of technologies as part of its framework to build web sites.

## Components
The stack comprises the following components:

Name       | Version    | Description
-----------|------------|------------------------------
Ubuntu     | Wheezy     | Operating system
MySQL      | 5.5        | Database
Apache     | 2.2        | Web server
PHP        | 5.4.4      | Scripting language


## Usage

### Start the Container
Start your image binding host port 8080 to port 80 (Apache Web Server) and 443:443 (HTTPS port) in your container:

    docker run -d -t -p 8080:80 -p 443:443 dell/drupal

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
Pre-built Image   | dell/drupal


<a name="issues"></a>
## Issues
The original Tutum image did not expose the **/var/www/html** folder. This made it impossible to update the web site, without using **nsenter**. Additionally, if a volume were specified, the folder would be empty.
* Upstart on Docker is broken due to [this issue][docker_upstart_issue], and that's one of the reasons the image is puppetized using vagrant.
* Warning: This is still in development and ports shouldn't be open to the outside world.

