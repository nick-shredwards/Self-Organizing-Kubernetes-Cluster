# Ansibilizing kubernetes for the Raspberry Pi OS
<p> The "Kubernetes on Raspberry Pi OS" Repository is part of the "Ansibilize Kubernetes" Group. </p>
<p> Its purpose is to make the process of creating a Raspberry Pi Kubernetes cluster faster and more convenient. </p>

<br><br>
<h3>Edits made/to be made to the scripts</h3>
<list>
	<p>Changed the command which deploys weave net to ensure the appropriate version is used</p>
	<p>There are some disrepancies between the filenames of the scripts being deleted and the scripts which are downloaded</p>
	<p>The initmaster_single script is not executable outside of usr/bin directory, probably due to having multiple users? should now work fine within the usr or usr/bin directory</p>
	<p>The docker components are not being removed automatically for some reason, creates errors whith the new installation</p>
	<p>There are some recommended edits suggested after Kubernetes installation, should be addressed</p>
	<p>Figure out a new ansible-pull command</p>
	<p>Figure out how to push the worker srcript from master to workers</p>
	<p>Figure out the new ansible-pull</p>
</list>
<h3>To use</h3>
    <p> To use this playbook, you can use(need deploy token from RAB)</p>
        <code>ansible-pull -U https://ADD_DEPLOY_TOKEN_HERE@stogit.cs.stolaf.edu/pdc/s21/soc.git</code>
	<p> Use Kubernetes version 1.21.0-00 and manually remove the all docker components</p>
	<br>
	<h3>Creation process</h3>
	<h5>Initializing the script</h5>
	    <p> This will be done by local.yml, which will run the actuall process described below.</p>
	        <p>Before running any installation processes, local.yml will ask the user to input their desired version of kubernetes. The version is saved and will be used later in this process. All the versions of Kubernetes can be seen <a href="https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-arm64/Packages">here</a>. </p>
		    <p> After the input, local.yml will call the files that initiate the installation process.</p>

<h5>Installing Docker</h5>
    <p> This process is located in the file install.docker.yml. It consists of 2 parts: </p>
        <ul>
	        <li>First it is necessary to uninstall any previous versions of docker and kubernetes, if there are any. We know that some Raspberry Pis may be just imaged, so to combat any errors that might arise from a lack of previous versions of kubernetes and Docker, ansible will ignore any errors that might arise from this process.</li>
		        <li>Then Docker will be installed using the script that is located in https://get.docker.com. After the script is downloaded and executed, he pi user will be added to the docker group.</li>
			    </ul>

<h5>Installing kubernetes</h5>
    <p> This process is located in the file install.kubernetes.yml </p>
        <p> Like the previous file, it hosts more than just the installation of kubernetes: </p>
	    <ul>
	            <li>Before installing kubernetes, the script will disable swap, due to the fact that swap is can cause errors when running commands and slows processes down.</li>
		            <li>After that the script will enable cgroups_memory in cmdline.txt.</li>
			            <li>This begins the installation process of kubernetes. The kubernetes version that is installed will be the one that the user input at the start of the process.</li>
				            <li>Installing scripts to finalize the process. At this point a reboot is recommended to apply some of the changes listed above. Despite not having turned the Raspberry Pi into a worker node or head node, ansible will install scripts on the computer to run the rest of the process:</li>
					            <ul>
						                <li><strong> initmaster_single.sh </strong>: This process will turn the Raspberry Pi into a kubernetes head node. It will initialize the Pi as the head node (it might take some time), and then will run commands to allow the user to run kubectl commands. After this is done, the script will install a Container Network Interface (CNI). A few minutes after this script finishes, please run <em>kubectl get nodes</em> to ensure that the headnode is up and running. <strong> To utilize this please run <code>initmaster_single</code></strong>.</li>
								            <li><strong> finalizeworker.sh </strong>: This process will turn the Raspberry Pi into a kubernetes worker node. It is advised that a head node has already been set up by the time this process runs. The user will be prompted to enter the IP address of the headnode and their username for that headnode. After that, the script will ssh into the headnode using the user's credentials, prompt the head node to print a command for the worker node to join the headnode and then store it in a file in a bash script in the Raspberry Pi that is to become a worker node. Then the bash script will be run by finalizeworker.sh. It might take a few minutes before the worker node is marked as ready, when running kubectl. <strong> To utilize this please run <code>sudo finalizeworker</code></strong>.</li>
									                <li><strong> install_loadbal.sh </strong>: This process will initiate an ansible script for the user to install a load balancer which will allow for a Highly Available Cluster. More instructions will be given by the script itself before and after it makes any changes to your system. <strong> To utilize this please run <code>install_loadbal</code></strong>.</li>
											        </ul>
												    </ul>

<br>

<h3>Sources</h3>
    <p> The ansibilization of kubernetes on the Raspberry Pis was done using these sources: </p>
        <ul>
	        <li> https://www.youtube.com/watch?v=XvlkYL1dGbw </li>
		        <li> https://kubecloud.io/setup-a-kubernetes-1-9-0-raspberry-pi-cluster-on-raspbian-using-kubeadm-f8b3b85bc2d1 </li>
			        <li> https://dev.to/anton2079/kubernetes-k8s-private-cloud-with-raspberry-pi-4s-k0d </li>
				    </ul>

# Self Organizing Clusters with Kubernetes

soc     Cluster Master  musins1,daly1,edward7,quist1    Self Organizing Clusters with Kubernetes

To get the Kubernetes cluster to self organize, follow the above steps to download all necessary software, then run the script ~/soc/add_workers.sh as root to automatically add all available nodes. Ensure you also have root access on all the worker pi nodes for the kubeadm join command that is in the script.
