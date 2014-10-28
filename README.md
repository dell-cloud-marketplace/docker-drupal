# docker-drupal
This blueprint installs a [Docker](http://docker.io) container for [Drupal](https://www.drupal.org/) – an open source content management platform that uses a range of technologies as part of its framework to build web sites.

This will try to go in line with [Drupal automated-testing](https://drupal.org/automated-testing).

* [Components](#components)
* [Usage](#usage)
    * [Basic Example](#basic-example)
* [Administration](#administration)
    * [Connecting to MySQL](#connecting-to-mysql)
    * [Updating the Application](#updating-the-application)
    * [Connecting to MySQL from the Application](#connecting-to-mysql-from-the-application)
* [Reference](#reference)
    * [Image Details](#image-details)
    * [Dockerfile Settings](#dockerfile-settings)
    * [Port Details](#port-details)
    * [Volume Details](#volume-details)
    * [Additional Environmental Settings](#additional-environmental-settings)
* [Blueprint Details](#blueprint-details)
* [Building the Image](#building-the-image)
* [Issues](#issues)

<a name="components"></a>
## Components
The stack comprises the following components:

Name       | Version    | Description
-----------|------------|------------------------------
Ubuntu     | Wheezy     | Operating system
MySQL      | 5.5        | Database
Apache     | 2.2        | Web server
PHP        | 5.4.4      | Scripting language


<a name="usage"></a>
## Usage

<a name="basic-example"></a>
### Basic Example
Start your image binding host port 8080 to port 80 (Apache Web Server) and 443:443 (HTTPS port) in your container:

    docker run -d -t -p 8080:80 -p 443:443 dell/drupal

## Test your deployment:

You can test your deployment by accessing Drupal console at:

    http://instance_ip:8080
    
 or
 
    https://instance_ip
    
(The container IP can be obtained by using "docker inspect ")    
Before accessing the Drupal console through HTTPS, you must accept the SSL certificate.

You can also test the application with cURL command:

    curl http://localhost:8080/


<a name="complete_installation"></a>
## Complete the installation
From the Drupal console, log in with admin/admin and start adding content.

<a name="administration"></a>
## Administration
Under construction.

<a name="connecting-to-mysql"></a>
### Connecting to MySQL
Under construction.

<a name="updating-the-application"></a>
### Updating the Application
Under construction.

<a name="(#connecting-to-mysql-from-the-application)"></a>
### Connecting to MySQL from the Application
Under construction.

<a name="reference"></a>
## Reference

<a name="image-details"></a>
### Image Details

Attribute         | Value
------------------|------
Based on          | [Ricardo Amaro](https://github.com/ricardoamaro/docker-drupal.git)
Github Repository | [https://github.com/ghostshark/docker-drupal](https://github.com/ghostshark/docker-drupal)
Pre-built Image   | dell/drupal

<a name="dockerfile-settings"></a>
### Dockerfile Settings

Instruction | Value
------------|------
EXPOSE      | ['80', '443']
CMD         | ['/run.sh']

<a name="port-details"></a>
### Port Details

Port | Details
-----|--------
80   | Apache web server
443  | SSL

<a name="volume-details"></a>
### Volume Details
Under construction.

<a name="additional-environmental-settings"></a>
### Additional Environmental Settings
Under construction.

<a name="blueprint-details"></a>
## Blueprint Details
Under construction.

<a name="building-the-image"></a>
## Building the Image
Clone this repoistory and build the image from the docker-drupal folder with the following command:

```no-highlight
git clone https://github.com/ghostshark/docker-drupal.git
cd docker-drupal
docker build -t dell/drupal .
```

<a name="issues"></a>
## Issues
The original Tutum image did not expose the **/var/www/html** folder. This made it impossible to update the web site, without using **nsenter**. Additionally, if a volume were specified, the folder would be empty.
* Upstart on Docker is broken due to [this issue][docker_upstart_issue], and that's one of the reasons the image is puppetized using vagrant.
* Warning: This is still in development and ports shouldn't be open to the outside world.


### Credentials

* ROOT   MYSQL_PASSWORD will be on /mysql-root-pw.txt
* DRUPAL MYSQL PASSWORD will be on /drupal-db-pw.txt
* Drupal account-name=admin & account-pass=admin


## License
GPL v3

[author]:                 https://github.com/ricardoamaro
[docker_upstart_issue]:   https://github.com/dotcloud/docker/issues/223
[docker_index]:           https://index.docker.io/
