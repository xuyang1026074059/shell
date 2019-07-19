#! /bin/bash
read "label? master or node"
if [ $label x == master x ];then
	echo "master"
else
	echo "node"
fi
