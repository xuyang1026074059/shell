#！/bin/sh

echo -e "***************************\n"
read -p "请按照顺序输入你的* yaml名称 * RC服务名称 * nodeport 端口* :" appname rcname nodeport
echo -e "start to make $appname project yaml\n"

function modify_yaml()
{
	cd /root/yaml
	cp -r base.yaml $appname.yaml
	sed -i 's/base/$rcname/g' ./$appname.yaml
	sed -i 's/baseport/$nodeport/g' ./$appname.yaml
	echo 
}

function start()
{
if [ "$#" -ne "3" ]; then
	echo -e " you should input three vars!!!,you should exec this script again!!"
	exit 0
else
    if [ "$nodeport" -ge "32766" || "$nodeport" -le "30000" ]; then
		read -p "your nodeport out of kubernetes port range, 30000< 32766 ,please input your new nodeport :" nodeport
		modify_yaml $appname $rcname $nodeport	
fi
}

function stop()
{
	echo -e "the $appname yaml has alread be created ! you can use it now!\n"
}

start 
stop


