#! /bin/bash
set -x
set -e

#this script for install mysql mongodb redis nginx docker 

mysql_install(){
	echo "start to install mysql"
	tar -zvxf /root/software/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz -C $1/mysql-5.7.22
        cd $1/myql-5.7.22
        mkdir -p grdata/data logs
        cp -r /root/software/my.cnf $1/mysql-5.7.22/grdata/
        touch logs/error.log
        touch logs/slowquery.log
	sed -i 's/\/data/\$1/g' $1/mysql-5.7.22/grdata/my.cnf
}

mongodb_intall(){
	tar -zvxf /root/sofrware/mongodd-linux-x86_64-3.6.3.tgz -C $1/mongodb-3.6.3
        cd $1/mongodb-3.6.3/
	mkdir -p mongodb-data/db
	mkdir -p logs
	touch logs/mongodb.log
	touch mongodb.pid
	cp /root/software/mongodb.conf $1/mongodb-3.6.3/bin/
	sed -i 's/192.168.0.1/\$2/g' $1/mongodb-3.6.3/bin/mongodb.conf
	sed -i 's/\/data/\$1/g'  $1/mongodb-3.6.3/bin/mongodb.conf
	cd  $1/mongodb-3.6.3/bin/
	./mongod --config ./mongodb.conf
}

redis_install(){
	tar -zvxf /root/software/redis-3.8.2.tar.gz -C $1/redis-3.8.2
	cd $1/redis-3.8.2
`	make
	mkdir -p $1/redis-3.2.8/bin
	cd $1/redis-3.8.2
	cp ./src/redis-server ./bin
	cp ./src/redis-cli ./bin
	cp /root/software/redis.conf ./
	sed -i 's/192.168.0.1/$2/g' ./redis.conf
	./bin/redis-server ./redis.conf
}

nginx_install(){
	yum -y install gcc automake autoconf libtool make zlib* pcre* openssl*
	tar -zvxf /root/software/nginx-1.9.12.tar.gz -C $1/nginx
	cd $1/nginx
	./configure --prefix=$1/nginx --with-http_stub_status_module --with-http_ssl_module --with-file-aio --with-http_realip_module
	mkdir -p logs
	touch logs/error.log
	touch logs/access.log
	./sbin/nginx
}

main(){
        tar -zvxf /root/sofrware.tar.gz 
	echo -e "please input you absoulte path!"
        ip=`ip addr  | grep inet | grep eth0 | awk -F / '{print \$1}' | awk -F ' ' '{print \$2}'`
	mysql_install $1
	mongodb_install $1 $ip
	redis_install $1 $ip
        nginx_install $1
	echo "has finished install mysql mongodb redis nginx"
}


