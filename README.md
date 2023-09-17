## OctoberCMS deploy tips & tricks

### Setup

- First uninstall/remove any apache packages or directories.
- Run [Server setup script](https://github.com/Samuell1/octobercms-deploy/blob/master/ServerSetup.sh) to install all packages needed.


### How to deploy to AWS Instances with AWS Codedeploy


### Optimalizations
Most of the bottlenecks of Laravel/OctoberCMS are that people forgot to do:

- Optimalize composer autoloader `composer install --optimize-autoloader` or `composer dump-autoload --optimize`
- Run `php artisan config:cache` to cache config files
- Run `php artisan route:cache` to cache routes
- Use PHP OPcache and JIT on server
- Disable debug and enable cache for everything
- Use memory cache (redis, memcached...)
- In custom plugins cache information that is request heavy
- Apply custom caching for values that are not needed to be accessed in realtime (For example category list, default values)

#### Optional optimalizations
- Use CDN for assets
- Queue workers for emails and other heavy tasks
