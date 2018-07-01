#！/bin/bash
## date: 2018-07-01

## &>/dev/null 表示把标准输出与错误输出都输出到 /dev/null 空设备

for num in {1...10}
do
	username=oldboy$num
	password=`head -c 500 /dev/urandom | md5sum | head -c 8`
	egrep "^$username" /etc/passwd >& /dev/null
	if [[ $? -ne 0 ]];then
		useradd $username
		echo $password | passwd $username --stdin $>/dev/null
		if [[ $? -eq 0]];then
			echo "$username:password" >> /root/user.txt
		fi
	fi
done