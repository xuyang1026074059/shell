#！/bin/bash

all_num=10
a=$(date +%H%M%S)
for num in `seq 1 ${all_num}`
do {
	sleep 1
	echo ${num}
} &

done

b=$(date +%H%M%S)
echo -e "startTime:\t$a"
echo -e "endtime:\t$b"
