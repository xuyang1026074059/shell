#! /bin/bash
echo "start to up mysql"
/data/mysql-5.7.22/bin/mysqld  --defaults-file=/data/mysql-5.7.22/grdata/my.cnf &

sleep 3s

echo "start to up mongodb"
/data/mongodb-3.6.3/bin/mongodb --config /data/mongodb-3.6.3/bin/mongodb.conf

sleep 8s

echo "start to up redis"
/data/redis/bin/redis-server /data/redis/redis.conf

echo "start to up nginx"
/data/nginx-1.9.12/sbin/nginx

