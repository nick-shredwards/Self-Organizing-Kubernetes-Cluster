#!/bin/bash
add_workers(){
    awk 'NR!=1' hostfile > ~/nodes.txt
    echo "input username"
    read $user
    while read ip
    do
	kubeadm token create --print-join-command > "/usr/joincommand-$ip.sh"
	chmod u+x "/usr/joincommand-$ip.sh"
	ssh "$user@$ip" 'echo "rootpass" | sudo -Sv && bash -s' < "/usr/joincommand-$ip.sh"
	process_id=$!
	wait $process_id
	echo "Exit status: $?"
        done < ~/nodes.txt
}

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
else
    add_workers
fi
