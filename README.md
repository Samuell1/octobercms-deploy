## OctoberCMS deploy tips & tricks

## Setup

- First uninstall/remove any apache packages or directories.
- Run [Server setup script](https://github.com/Samuell1/octobercms-deploy/blob/master/ServerSetup.sh) to install all packages needed.

## Deployment to AWS Instances with AWS CodeDeploy

#### codedeploy-scripts directory

The `codedeploy-scripts` directory contains the following scripts:

- `beforeinstall.sh`: This script is executed before the installation process begins. It removes the contents of the `/var/www/html/` directory and creates a new directory.
- `afterinstall.sh`: This script is executed after the installation process is complete. It sets the necessary permissions, installs composer dependencies, builds the theme, pushes new assets to the CDN, clears the cache, creates a config cache, and runs migrations.
- `applicationstart.sh`: This script is executed when the application starts. It restarts the PHP and Nginx services.
- `applicationstop.sh`: This script is executed when the application stops. It stops the Nginx and PHP services.
- `appspec.yml`: This file defines the deployment process, including the files to be copied and the hooks to be executed.
- `restart-codedeploy-agent.sh`: This script restarts the CodeDeploy agent to prevent memory leaks.

#### ServerSetup.sh script

The `ServerSetup.sh` script is used to set up the server with the necessary dependencies and configurations. It performs the following tasks:

- Updates the package list.
- Installs the required dependencies, including PHP, Nginx, and AWS CodeDeploy agent.
- Retrieves the instance details.
- Installs Composer.
- Installs the AWS CodeDeploy agent.
- Restarts the PHP and Nginx services.

#### nginx and php-fpm configuration files

The `nginx` directory contains the configuration files for the Nginx web server. The `default` file is the main configuration file for the server, and the `nginx.conf` file contains the global configuration settings.

The `php-fpm` directory contains the configuration files for PHP-FPM. The `php-fpm.conf` file is the main configuration file for PHP-FPM, and the `pool.d/www.conf` file contains the configuration settings for the `www` pool.

## Optimalizations

#### Optimize Composer Autoloader

- Optimalize composer autoloader `composer install --optimize-autoloader` or `composer dump-autoload --optimize`

The class loader used while developing the application is optimized to find new and changed classes. In production servers, PHP files should never change, unless a new application version is deployed. That's why you can optimize Composer's autoloader to scan the entire application once and build an optimized "class map", which is a big array of the locations of all the classes and it's stored in vendor/composer/autoload_classmap.php.

Execute this command to generate the new class map (and make it part of your deployment process too):

`composer dump-autoload --no-dev --classmap-authoritative`

- `--no-dev` excludes the classes that are only needed in the development environment (i.e. require-dev dependencies and autoload-dev rules);
- `--classmap-authoritative` creates a class map for PSR-0 and PSR-4 compatible classes used in your application and prevents Composer from scanning the file system for classes that are not found in the class map. (see: Composer's autoloader optimization).

#### Cache Config Files

- Run `php artisan config:cache` to cache config files

Caching the configuration files can improve the performance of your application by reducing the time it takes to load the configuration settings. This is done by running the `php artisan config:cache` command, which creates a single cached configuration file that is loaded on each request.

#### Cache Routes

- Run `php artisan route:cache` to cache routes

Caching the routes can improve the performance of your application by reducing the time it takes to load the route definitions. This is done by running the `php artisan route:cache` command, which creates a single cached route file that is loaded on each request.

#### Configure OPcache and JIT for Maximum Performance

The default OPcache configuration is not suited applications, so it's recommended to change these settings as follows:

```
; php.ini
; maximum memory that OPcache can use to store compiled PHP files
opcache.memory_consumption=256

; maximum number of files that can be stored in the cache
opcache.max_accelerated_files=20000
```

#### Don't Check PHP Files Timestamps

In production servers, PHP files should never change, unless a new application version is deployed. However, by default OPcache checks if cached files have changed their contents since they were cached. This check introduces some overhead that can be avoided as follows:

```
; php.ini
opcache.validate_timestamps=0
```

After each deployment, you must empty and regenerate the cache of OPcache. Otherwise you won't see the updates made in the application. Given that in PHP, the CLI and the web processes don't share the same OPcache, you cannot clear the web server OPcache by executing some command in your terminal. These are some of the possible solutions:

- Restart the web server;
- Call the `apc_clear_cache()` or `opcache_reset()` functions via the web server (i.e. by having these in a script that you execute over the web);
- Use the cachetool utility to control APC and OPcache from the CLI.

#### Disable Debug and Enable Cache

- Disable debug and enable cache for everything

Disabling the debug mode and enabling caching for everything can improve the performance of your application by reducing the amount of information that is logged and the time it takes to load the cached data. This is especially important in production environments where performance is critical.

#### Use Memory Cache

- Use memory cache (valkey, dragonflydb, redis, memcached...)

Using a memory cache can significantly improve the performance of your application by reducing the time it takes to retrieve data from the database. This is done by storing the frequently accessed data in memory, which can be quickly retrieved without the need to query the database.

#### Cache Information in Custom Plugins

- In custom plugins cache information that is request heavy

Caching the information that is request heavy in custom plugins can improve the performance of your application by reducing the time it takes to retrieve the data. This is done by storing the frequently accessed data in a cache, which can be quickly retrieved without the need to perform the expensive operations.

#### Apply Custom Caching for Non-Realtime Values

- Apply custom caching for values that are not needed to be accessed in realtime (For example category list, default values)

Applying custom caching for values that are not needed to be accessed in real-time can improve the performance of your application by reducing the time it takes to retrieve the data. This is done by storing the non-realtime values in a cache, which can be quickly retrieved without the need to perform the expensive operations.

#### Optional Optimalizations

- Use CDN for assets
- Queue workers for emails and other heavy tasks

Using a CDN (Content Delivery Network) for assets can improve the performance of your application by reducing the time it takes to load the static assets such as images, CSS, and JavaScript files. This is done by distributing the assets across multiple servers, which can be quickly retrieved from the nearest server.

Using queue workers for emails and other heavy tasks can improve the performance of your application by offloading the heavy tasks to the background. This allows the application to quickly respond to the user requests without waiting for the heavy tasks to complete.
