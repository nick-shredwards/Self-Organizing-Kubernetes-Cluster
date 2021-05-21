#!/bin/bash
add_workers(){
    awk 'NR!=1' hostfile > ~/nodes.txt
    echo "input username"
    read user
    echo "input password"
    read -s password
    while read ip
    do
	echo "ip: $ip" 
	x=$(kubeadm token create --print-join-command)
	ssh "$user@$ip" "echo $password | sudo -S $x"
        done < ~/nodes.txt
}

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
else
    add_workers
fi
