#！ /bin/bash
#########################
# date :2018-06-19
# Description : to acquire usage of cpu mem disk 
#########################

# acquire cpu useage
function cpu_check(){
	cpuUsage=`top -n 1 | grep "Cpu" | awk -F ' ' '{print $2}'`
	return cpuUsage
}

# acqucire disk usage
function disk_check(){
	disklog=/root/logfile-disk
	diskUsage=`df -h | awk -F '[ %]+' {print $5}`
	if [[ $"diskUsage" > 80 ]];then
		echo "diskUsage over 80% ，please clean trash packages !!" >> $disklog
		cat $disklog | mail -s "xxxxxxx" xxxx@163.com
	fi
}

function main(){
	cpulog=/root/logfile-cpu
	now_time=`date '+%F %T'`
	number=cpu_check()
	if [[ "$number" > 60 ]];then
		 echo "报警时间：${now_time}" > $logFile
         echo "CPU使用率：${cpuUsage}%  over 60%, hope you to watch the warning " >> $logFile
         mail -s "cpu ouverload 60%" xxxx@163.com  < $logFile 
    fi
    disk_check
}

