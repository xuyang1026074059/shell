#! /bin/bash

##get the true number via the md5 number.
##written by zhdya_20171010

for n in `seq 0 32767`
do
	a=`echo $n |md5sum | cut -c 1-8`
	for m in `cat /tmp/md5.txt`
	do
		if [ "$m" == "$a" ]
		then
			echo "for the $m, the true number is $n"
		fi
	done
done
