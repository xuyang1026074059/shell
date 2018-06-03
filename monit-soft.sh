#! /bin/bash


if ps -ef|grep "mysql"|egrep -v grep >/dev/null
then
        echo ok!
else
        /data/mysql-5.7.22/bin/mysqld --defaults-file=/data/mysql-5.7.22/grdata/my.cnf &
fi

if ps -ef|grep "mongod"|egrep -v grep >/dev/null
then
        echo ok!
else
        /data/mongodb-3.6.3/bin/mongod --config /data/mongodb-3.6.3/bin/monogodb.conf
fi

if ps -ef|grep "redis"|egrep -v grep >/dev/null
then
        echo ok!
else
        /data/redis/bin/redis /data/redis/redis.conf
fi

if ps -ef|grep "nginx"|egrep -v grep >/dev/null
then
        echo ok!
else
        /data/nginx/sbin/nginx
fi





