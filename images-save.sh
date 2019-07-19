#! /bin/bash

set -x
set -e

docker save quay.io/calico/node:v3.0.4 k8s.gcr.io/kube-proxy-amd64:v1.10.0 k8s.gcr.io/kube-scheduler-amd64:v1.10.0 k8s.gcr.io/kube-apiserver-amd64:v1.10.0 k8s.gcr.io/kube-controller-manager-amd64:v1.10.0 quay.io/calico/kube-controllers:v2.0.2 quay.io/calico/cni:v2.0.3 k8s.gcr.io/etcd-amd64:3.1.12 k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.8 k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8 k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8 k8s.gcr.io/pause-amd64:3.1 quay.io/coreos/etcd:v3.1.10 > kubernetes-1.10.tar 
