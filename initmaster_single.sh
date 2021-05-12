#!/bin/bash
master () {
    sudo kubeadm init

    mkdir -p $HOME/.kube
    sudo cp -if /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    curl "https://cloud.weave.works/k8s/v1.16/net.yaml" > cni.yaml
    sed -i "s/weave-npc:.*\..*\..*'/weave-npc:2.6.5'/g" "cni.yaml" && sed -i "s/weave-kube:.*\..*\..*'/weave-kube:2.6.5'/g" "cni.yaml"
    kubectl apply -f cni.yaml

}

if [ "$EUID" -eq 0 ]
then
    echo "Please don't run as root"
else
    master
fi
