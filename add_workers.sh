#!/bin/bash
awk 'NR!=1' hostfile > ~/nodes.txt
echo "input username"
read $user
while read ip
do
    echo "line: $ip"
    kubeadm token create --print-join-command > joincommand.sh
    chmod u+x joincommand.sh
    scp joincommand.sh "$user@$ip"
    ssh "$user@$ip" sudo ./joincommand.sh
    done < ~/nodes.txt
