 #!/bin/bash
 #cd ../
 #mkdir Code
 #cd Code



 #echo "Correcting filesystem permissions..."

 #sudo su find var vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;
 #sudo su find var vendor pub/static pub/media app/etc -type d -exec chmod u+w {} \;
# sudo u+x bin/magento

 #echo "Filesystem permissions corrected."

 #cd ../
 #cd ece-tools
 #./prune.sh
 ln -s  ../../pf/ magento-sync
 echo 'symlink created'
 cp .docker/magento/env.php  magento-sync/app/etc/
 cp .docker/magento/auth.json  magento-sync/auth.json
 echo 'env.php and auth.json copied'
 docker-compose down

 docker-compose -f docker-compose.yml up --build -d

 docker exec -d ece-tools_varnish_1 varnishadm 'ban req.url ~ .'
 docker exec -d ece-tools_fpm_1 rm -rf var/cache/* var/page_cache/* generated/*
 docker exec -d ece-tools_redis_1 redis-cli flushall
