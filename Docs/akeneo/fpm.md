# Akeneo with PHP FPM and Nginx

## Using the images

The simplest way to run the containers is to copy the [FPM compose file](https://github.com/damien-carcel/Dockerfiles/blob/master/Docs/akeneo/docker-compose.yml.fpm_dist) at the root of your project (don't forget to rename it `docker-compose.yml`).

You can place it somewhere else, but then you will need to change the volumes parameter from `./:/home/docker/pim` to `/the/path/to/your/pim:/home/docker/pim` (you'll need to do it for both `nginx` and `nginx-behat` services).

Create on your host a folder `/tmp/behat/screenshots` (or anywhere else according to you compose file) with full read/write access to your user, otherwise `docker-compose` will create it, but with write access only for root, and your behat tests will fail.

By default, `carcel/akeneo-fpm:php-7.1` is used in the compose file.
Read the [Tags available](https://github.com/damien-carcel/Dockerfiles/blob/master/README.md#github-branches-and-corresponding-docker-hub-tags) section of the `README.md` for more details.

## Run and stop the containers

**All `docker-compose` commands are to be ran from the folder containing the compose file.**

To start your containers, just run:

```bash
$ docker-compose up -d
```

To stop the containers, run:

```bash
$ docker-compose stop
```

but if you want to completely remove everything (containers, networks and volumes), then run:

```bash
$ docker-compose down -v
```

This, of course, will not delete the Akeneo application you cloned on your machine, only the Docker containers. 

## Install and run Akeneo

### Configure Akeneo

First, make sure that Akeneo database settings are as the containers expect them:

```yaml
# /host/path/to/you/pim/app/config/parameters.yml
parameters:
    database_driver: pdo_mysql
    database_host: mysql
    database_port: null
    database_name: akeneo_pim
    database_user: akeneo_pim
    database_password: akeneo_pim
    locale: en
    secret: ThisTokenIsNotSoSecretChangeIt
```

```yaml
# /host/path/to/you/pim/app/config/parameters_test.yml
parameters:
    database_driver: pdo_mysql
    database_host: mysql-behat
    database_port: null
    database_name: akeneo_pim
    database_user: akeneo_pim
    database_password: akeneo_pim
    locale: en
    secret: ThisTokenIsNotSoSecretChangeIt
    installer_data: PimInstallerBundle:minimal
```

If you want to use MongoDB storage, add the following to your PIM parameters:

```yaml
# /host/path/to/you/pim/app/config/parameters.yml and parameters.yml.dist ; the last one is important too, to avoid removal on "composer update"
parameters:
    ...
    pim_catalog_product_storage_driver: doctrine/mongodb-odm
    mongodb_server: 'mongodb://mongodb:27017'
    mongodb_database: akeneo_pim
```

```yaml
# /host/path/to/you/pim/app/config/parameters_test.yml
parameters:
    ...
    pim_catalog_product_storage_driver: doctrine/mongodb-odm
    mongodb_server: 'mongodb://mongodb-behat:27017'
    mongodb_database: akeneo_pim
```

For more details on Akeneo configuration, don't hesitate to look at [Akeneo official documentation on the subject](https://docs.akeneo.com/latest/developer_guide/installation/index.html).

### PHP 5.6 or PHP 7.x? dev or standard?

When using Akeneo with PHP 7.x and MongoDB storage, you need to add `alcaeus/mongo-php-adapter` in your requirements:

```bash
$ docker-compose exec fpm composer require --no-update --ignore-platform-reqs alcaeus/mongo-php-adapter
```

Akeneo exists in two editions: community (open-source) and enterprise (proprietary). Both comes with:

- a development version (`akeneo/pim-community-dev` on GitHub for the community edition),
- a standard version (`akeneo/pim-community-standard` on GitHub for the community edition) which is only an empty Symfony application, having `akeneo/pim-community-dev` in its vendors.

The development version is the one if you want to contribute to Akeneo project: adding new features, fixing bugs. The standard version is the one to create projects and use Akeneo in production.

The development version comes with `doctrine/mongodb-odm-bundle` already present in its composer requirements (needed for IDE autocompletion and unit tests).
So you always need to add `alcaeus/mongo-php-adapter` when using PHP 7.x, even if not using MongoDB storage.

This is not the case for the standard version.

### Install Akeneo

Don't forget to activate the `DoctrineMongoDBBundle` in `app/AppKernel.php` if you want to use MongoDB storage.

**Important:** if you are using PHP 7.x and you have `doctrine/mongodb-odm-bundle` in your requirements, you need to add the option `--ignore-platform-reqs` when running `composer update`.

Now, you can initialize Akeneo:

```bash
$ docker-compose exec fpm php -d memory_limit=-1 /usr/local/bin/composer update
$ docker-compose exec fpm pim-initialize
```

Command `pim-initialize` is detailed [below in this page](https://github.com/damien-carcel/Dockerfiles/blob/master/Docs/akeneo/fpm.md#scripts-available).

### Xdebug

*Xdebug* is deactivated by default. If you want to activate, you can turn the environment variable `PHP_XDEBUG_ENABLED` to `1`. Then you just have to run `docker-compose up -d` again.

Also, you can configure two things on Xdebug through environment variables on akeneo-fpm image. These environment variables are all optional.
- `PHP_XDEBUG_IDE_KEY`: the IDE KEY you want to use (by default `XDEBUG_IDE_KEY`)
- `PHP_XDEBUG_REMOTE_HOST`: your host IP address (by default it allows all IPs)

You should now be able to access Akeneo development environment from your host through `http://localhost:8080/` and behat environment through `http://localhost:8081/` (of course, you can change the host port in the compose file).

### Scripts available

The `akeneo-fpm` image comes with three little scripts to ease your Akeneo development and testing.

- [`pim-cac` script](https://github.com/damien-carcel/Dockerfiles/blob/master/akeneo-fpm/files/pim-cac.sh) will completely remove the application cache, then regenerate it in prod, dev and behat mode.

- [`pim-assets` script](https://github.com/damien-carcel/Dockerfiles/blob/master/akeneo-fpm/files/pim-assets.sh) will completely remove the application cache and assets (`web/bundles/*`, `web/css/*`, `web/js/*`).
    Then it will regenerate the cache and the ORO requirejs configuration, and dump all assets as symlinks.

    This command is to be used each time you have strange behavior on the front end (missing translations, modifications that do not appear in the forms…).

- [`pim-initialize` script](https://github.com/damien-carcel/Dockerfiles/blob/master/akeneo-fpm/files/pim-initialize.sh) will completely remove the application cache, logs, assets (`web/bundles/*`, `web/css/*`, `web/js/*`),
    and everything generated by any previous installation. Then it will regenerate the cache and the ORO requirejs configuration, perform a installation of Akeneo in production mode through the command `pim:install --force`, and dump all assets as symlinks.
    Finally, it will initialize the database (through `pim:installer:db`) for the behat environment.

    Basically, this command will provide you with a fresh PIM, as if it was its first installation.

## Run behat tests

The tests are to be run inside the containers. Start by configuring Behat:

```yaml
# /host/path/to/your/pim/behat.yml
default:
    paths:
        features: features
    context:
        class:  Context\FeatureContext
        parameters:
            base_url: 'http://nginx-behat/'
            timeout: 10000
            window_width: 1280
            window_height: 1024
    extensions:
        Behat\MinkExtension\Extension:
            default_session: symfony2
            show_cmd: chromium-browser %s
            selenium2:
                wd_host: 'http://selenium:4444/wd/hub'
            base_url: 'http://nginx-behat/'
            files_path: 'features/Context/fixtures/'
        Behat\Symfony2Extension\Extension:
            kernel:
                env: behat
                debug: false
        SensioLabs\Behat\PageObjectExtension\Extension: ~
```

You are now able to run behat tests.

```bash
$ docker-compose exec fpm bin/behat features/path/to/scenario
```

## What if?

### I want to see my tests running

The docker image `selenium/standalone-firefox-debug` comes with a VNC server in it. You need a VNC client, and to connect to `localhost:5900`. You will then be able to see you browser and your tests running in it!

### I never want to see my tests running

It is the default behavior, but in this case, you don't need to have a VNC server in your selenium container.

You can achieve that simply by replacing the image `selenium/standalone-firefox-debug` by `selenium/standalone-firefox`. The first is based on the second, simply adding the VNC server.

Don't forget to also remove the binding on port 5900, now useless as `selenium/standalone-firefox` does not expose it.
 
### I want to run my tests in Chrome instead of Firefox

Then all you need to do is to replace the image `selenium/standalone-firefox-debug` by `selenium/standalone-chrome-debug` (or `selenium/standalone-chrome` if you don't want to see the browser in action).
