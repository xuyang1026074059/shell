#! /bin/bash
# 用于统计文本中相同 IP 出现的次数，并且排序
# sort :
#      -n : 按照数值排序
#      -k:  按照列排序
#      -t:  分隔符
# 下面这个例子以第二列的数值排序输出
awk '{arr[$1]++;}END{for(i in arr){print i , arr[i] }}' test.txt | sort -n -k 2

