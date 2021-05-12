#!/bin/bash
worker (){
    echo "Please insert the IP address or name and domain of master node:"
    read headnode

    echo "Insert your username for $headnode: "
    read user

    ssh "$user@$headnode" kubeadm token create --print-join-command > joincommand.sh

    chmod u+x joincommand.sh
    ./joincommand.sh
}

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
else
    worker
fi
