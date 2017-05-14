# Troubleshooting

## I ran `composer update` on Akeneo PIM and end up with this message:

```bash
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - doctrine/mongodb-odm-bundle 3.2.0 requires doctrine/mongodb-odm ^1.1 -> satisfiable by doctrine/mongodb-odm[1.1.3, 1.1.0, 1.1.1, 1.1.2].
    - doctrine/mongodb-odm-bundle 3.2.0 requires doctrine/mongodb-odm ^1.1 -> satisfiable by doctrine/mongodb-odm[1.1.3, 1.1.0, 1.1.1, 1.1.2].
    - doctrine/mongodb-odm 1.1.3 requires doctrine/mongodb ~1.3 -> satisfiable by doctrine/mongodb[1.4.0, 1.3.0].
    - doctrine/mongodb-odm 1.1.0 requires doctrine/mongodb ~1.3 -> satisfiable by doctrine/mongodb[1.4.0, 1.3.0].
    - doctrine/mongodb-odm 1.1.1 requires doctrine/mongodb ~1.3 -> satisfiable by doctrine/mongodb[1.4.0, 1.3.0].
    - doctrine/mongodb-odm 1.1.2 requires doctrine/mongodb ~1.3 -> satisfiable by doctrine/mongodb[1.4.0, 1.3.0].
    - doctrine/mongodb-odm 1.1.3 requires doctrine/mongodb ~1.3 -> satisfiable by doctrine/mongodb[1.4.0, 1.3.0].
    - doctrine/mongodb 1.4.0 requires ext-mongo ^1.5 -> the requested PHP extension mongo is missing from your system.
    - doctrine/mongodb 1.3.0 requires ext-mongo ^1.5 -> the requested PHP extension mongo is missing from your system.
    - doctrine/mongodb 1.4.0 requires ext-mongo ^1.5 -> the requested PHP extension mongo is missing from your system.
    - Installation request for doctrine/mongodb-odm-bundle 3.2.0 -> satisfiable by doctrine/mongodb-odm-bundle[3.2.0].

  To enable extensions, verify that they are enabled in your .ini files:
    - /etc/php/php.ini
    - /etc/php/conf.d/apcu.ini
    - /etc/php/conf.d/imagick.ini
    - /etc/php/conf.d/mongodb.ini
    - /etc/php/conf.d/ssh2.ini
    - /etc/php/conf.d/xdebug.ini
  You can also run `php --ini` inside terminal to see which files are used by PHP in CLI mode.
```

You are certainly using PHP 7.x while having `doctrine/mongodb-odm-bundle` in your requirements.

You have to run composer with the `--ignore-platform-reqs` argument, as Akeneo 1.x uses an old version of `doctrine/mongodb`.
Even if it is compatible with PHP 7.x, its composer requirements checks only for the PHP 5.x MongoDB extension (`ext-mongo`), not for the PHP 7.x one (`php-mongodb`).

## I cannot access `app_dev.php` on Symfony applications

To access Symfony dev mode, through `http://localhost:8080/app_dev.php`, you need to comment the `if (isset($_SERVER['HTTP_CLIENT_IP'])` condition in `web/app_dev.php`.
