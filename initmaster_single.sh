#!/bin/bash
master () {
    sudo kubeadm init

    mkdir -p $HOME/.kube
    sudo cp -if /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

}

if [ "$EUID" -eq 0 ]
then
    echo "Please don't run as root"
else
    master
fi
