## OctoberCMS deploy tips & tricks

### Setup


### How to deploy to AWS Instances with AWS Codedeploy


### Optimalizations
Most of the bottlenecks of OctoberCMS are that people forgot to do:

- Optimalize composer autoloader `composer install --optimize-autoloader`
- Run `php artisan config:cache` to cache config files
- Use OPcache on server
- Disable debug and enabled cache for everything
- Use memory cache (redis, memcached...)
- In custom plugins cache information that is request heavy
