#! /bin/bash

set -x
set -e

images=(
    kube-apiserver:v1.13.4
    kube-controller-manager:v1.13.4
    kube-scheduler:v1.13.4
    kube-proxy:v1.13.4
    pause:3.1
    etcd:3.2.24
    coredns:1.2.6
)

for imageName in ${images[@]}; 

do
    docker pull registry.aliyuncs.com/google_containers/$imageName
    docker tag  registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
done
