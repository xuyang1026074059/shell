#! /bin/bash

set -x
set -e

for image in $(docker images | grep -v TAG | awk '{print $1}');
do

     service=`echo $image | awk -F '/' '{print $2}'`
     fullname=`docker images| grep $image | awk '{print $1":"$2}'`
     tag=`docker images | grep $image | awk '{print $2}'`
     docker tag $fullname k8s.gcr.io/$service:$tag
done
