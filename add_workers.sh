#!/bin/bash
add_workers(){
    awk 'NR!=1' hostfile > ~/nodes.txt
    echo "input username"
    read $user
    while read ip
    do
	echo "line: $ip"
	
	kubeadm token create --print-join-command > "joincommand-$ip.sh"
	chmod u+x "joincommand-$ip.sh"
	scp "joincommand-$ip.sh" "$user@$ip:/usr/local/bin"
	ssh "$user@$ip" "/usr/local/bin/joincommand-$ip.sh"
	process_id=$!
	wait $process_id
	echo "Exit status: $?"
        done < ~/nodes.txt
}

if [ "$EUID" -ne 0 ]
then
    add_workers
    #echo "Please run as root"
else
    add_workers
fi
