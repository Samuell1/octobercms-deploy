#!/bin/bash

echo "Running Hook: applicationstart"

# restart php and nginx
service php7.3-fpm restart
service nginx restart

echo "Finished running hook: applicationstart"

exit 0
