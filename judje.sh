#! /bin/sh

while true;
do
    read -p "Do you wish to install this program,please intput your choice: " yn
    case $yn in
         [Yy]* ) echo "start to intall this program..........";break;;
         [Nn]* ) echo "not to install this program...........";exit;;
           *   ) echo "Please answer yes or no";;
     esac
done


