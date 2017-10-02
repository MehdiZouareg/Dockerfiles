# Akeneo Dockerfiles

[![Build Status](https://travis-ci.org/akeneo/Dockerfiles.svg?branch=master)](https://travis-ci.org/akeneo/Dockerfiles)

This repository contains Dockerfiles to be used for Akeneo PIM and other PHP or Symfony development/testing. Feel free to use/adapt them if they fit your needs.

**These images do not contain Akeneo PIM**.

## Images and tags available

- [**akeneo/php**](php/README.md): An image with PHP CLI preconfigured, based on `debian:jessie-slim` or `debian:stretch-slim`
- [**akeneo/fpm**](fpm/README.md): An image with PHP FPM preconfigured, to be used with any PHP project, based on `akeneo/php` (needs to be run along `nginx` or `httpd`)
- [**akeneo/apache-php**](apache-php/README.md): An image with Apache + mod_php preconfigured, to be used with any PHP project, based on `akeneo/php`

All images are available as follow:

| PHP version | Based on                                                                                     | Corresponding tags        |
|-------------|----------------------------------------------------------------------------------------------|---------------------------|
| 5.6         | Debian 8 "Jessie" with native PHP package                                                    | akeneo/php:5.6            |
|             |                                                                                              | akeneo/fpm:php-5.6        |
|             |                                                                                              | akeneo/apache-php:php-5.6 |
| 7.0         | Debian 9 "Stretch" with native PHP packages                                                  | akeneo/php:7.0            |
|             |                                                                                              | akeneo/fpm:php-7.0        |
|             |                                                                                              | akeneo/apache-php:php-7.0 |
| 7.1         | Debian 9 "Stretch" with packages coming from [Ondřej Surý repository](https://deb.sury.org/) | akeneo/php:7.1            |
|             |                                                                                              | akeneo/fpm:php-7.1        |
|             |                                                                                              | akeneo/apache-php:php-7.1 |

For all images, tag `latest` is identical to the one corresponding to the most recent PHP version.

Please, remember that only Apache + mod_php, with PHP 5.6, is officially supported by Akeneo 1.7 and previous versions.
On the other hand, Akeneo 2.O is to be used only with PHP 7.1, with php-fpm and Apache 2.4 with FCGI.

## How to use these images

If you are new to Docker, please start with the [getting started section](https://github.com/akeneo/Dockerfiles/blob/master/Docs/getting-started.md).
And even if you are not new, it is a good start to understand how these images are intended to be used.

Then, you can find out how to use these images in detail:
- for PHP application development in the [Symfony docker-compose section](https://github.com/akeneo/Dockerfiles/blob/master/Docs/symfony/compose.md).
- for Akeneo development and behat testing in the [official Akeneo documentation](https://docs.akeneo.com/).

Please read carefully the [troubleshoothing section](https://github.com/akeneo/Dockerfiles/blob/master/Docs/troubleshooting.md) if you encounter any problem.
If your problem is not listed in it, don't hesitate to [open an issue](https://github.com/akeneo/Dockerfiles/issues).

## License

This content of this repository is under the MIT license. See the complete license in the [LICENSE](https://github.com/akeneo/Dockerfiles/blob/master/LICENSE) file.
