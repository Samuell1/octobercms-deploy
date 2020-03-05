#!/bin/bash

echo "Running hook: afterinstall"

# Go in website folder
cd /var/www/html/

# usermod -a -G www-data ubuntu
chown -R www-data:www-data /var/www/html/

# set permissions
chgrp -R www-data /var/www/html/storage
chmod -R 775 /var/www/html/storage
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/vendor

# set permissions to cache composer, npm files
chown -R www-data:www-data /home/ubuntu/.composer
chown -R www-data:www-data /home/ubuntu/.npm
chown -R www-data:www-data /home/ubuntu/.config

# install composer
composer install --no-ansi --no-dev --no-interaction --no-progress --prefer-dist --optimize-autoloader

# set permissions on vendor packages
chown -R www-data:www-data /var/www/html/vendor

# Go in website theme folder
cd /var/www/html/themes/dr
# install npm in theme
npm install --loglevel verbose
# build theme
npm run build:prod --loglevel verbose

# Go in website folder
cd /var/www/html/

# push new assets to CDN
php artisan cdn:sync dr

# clear cache
php artisan cache:clear

# create config cache
php artisan config:cache

# run migrations
php artisan october:up

echo "Finished running hook: afterinstall"

exit 0
