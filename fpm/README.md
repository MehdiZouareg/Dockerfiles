# PHP FPM on Docker

[![Build Status](https://travis-ci.org/akeneo/Dockerfiles.svg?branch=php-5.6)](https://travis-ci.org/akeneo/Dockerfiles/tree/php-5.6)

This is a basic Docker environment for PHP FPM development, based on [akeneo/php](https://hub.docker.com/r/akeneo/php). **This image does not contain Akeneo PIM**.

It is intended to be used [httpd](https://hub.docker.com/_/httpd) with FCGI enable or [nginx](https://hub.docker.com/_/nginx).

It comes with native Debian Jessie PHP 5.6, and some PHP extensions: fpm of course, but also apcu, mcrypt, intl, mysql, curl, gd, mongo, and xdebug (this last one comes deactivated, run `php5enmod xdebug` to enable it).

The PHP FPM daemon is configured with "docker" as user and group, and listen to the port `9001`.

## How to use it?

### From Docker hub

You can directly pull this image from [Docker hub](https://hub.docker.com/r/akeneo/apache-php/) by running:

```bash
$ docker run -d --name fpm akeneo/fpm:php-5.6
```

### From GitHub

Clone the repository, go inside the created folder, and build the docker image:

```bash
$ docker build -t "akeneo-fpm" .
```

Then you can run a container like this:

```bash
$ docker run --name fpm -d akeneo-fpm
```

## License

This repository is under the MIT license. See the complete license in the [LICENSE](https://github.com/akeneo/Dockerfiles/blob/master/LICENSE) file.
