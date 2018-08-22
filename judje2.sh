#! /bin/sh

echo "Do you wish to install this program ?"
select yn in "Yes" "No"; 
do
	case $yn in
	     Yes ) echo "start to install this program";break;;
             No  ) echo "start to exit this program";exit;;
        esac
done
