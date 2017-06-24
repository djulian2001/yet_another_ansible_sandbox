#!/bin/bash
UAPPNAME="$1"
SSHPASS="$2"

. "/vagrant/manage/source.variables"

# enable epel

sudo yum -y install epel-release
sudo yum --enablerepo=epel -y install epel-release

yum update -y
yum install -y git sshpass

# set up the ansible manager...
/bin/bash /vagrant/add_ansible_user.sh "$1" "$2" $3 "$4"

usermod -a -G vagrant ansible

# FUTURE:
# build a process for gathering the known_hosts global /ect/ssh/ssh_known_hosts   [default, will wanna symlink]
# source url: 	https://gist.github.com/bradland/1315165
#	will have to:
#		add the option "GlobalKnownHostsFile /etc/ssh/ssh_known_hosts"
#	run the command
#		for node in node_list:
#			ssh-keyscan -H node >> /usr/ansible/scripts/ssh_known_hosts 
#			ssh-keyscan -H node >> /etc/ssh/ssh_known_hosts 
#
#			ln -s /etc/ssh/ssh_known_hosts /usr/ansible/scripts/ssh_known_hosts 
#
#		for node in node_service_list:
#			ssh-keyscan -H node >> /usr/ansible/scripts/ssh_known_hosts 


# not safe lets us an env variable

export SSHPASS="$SSHPASS" && \
IP_FILE="/vagrant/manage/hosts"

IFS=$'\n'
set -f
for REMOTE_IP in $(cat < "$IP_FILE"); do
	/bin/echo "rsa key copy for $REMOTE_IP"
	
	cat "/home/$UAPPNAME/.ssh/id_rsa.pub" | sshpass -e ssh -y -o StrictHostKeyChecking=no "$UAPPNAME@$REMOTE_IP" "cat >> ~/.ssh/authorized_keys" 
	# /bin/echo "status: $?"

	sshpass -e ssh -y "$UAPPNAME@$REMOTE_IP" "chmod 600 ~/.ssh/authorized_keys" 
	# /bin/echo "status: $?"
done

# setup and install ansible with pip..
echo "INSTALL ansible using pip..."
sudo yum -y install python-pip python-devel openssl-devel.x86_64
sudo pip install --upgrade pip
sudo pip install ansible
sudo pip install --upgrade ansible
echo "INSTALL redis using yum and pip..."
sudo yum -y install redis
sudo service redis start
sudo pip install redis
sudo pip install --upgrade redis

echo "INSTALL wget using yum..."
sudo yum install -y wget.x86_64

# apt-get install -y software-properties-common
# apt-get update -y
# apt-add-repository -y ppa:ansible/ansible
# apt-get install ansible -y
# apt-get autoremove -y

# there probably needs to be a host publishing step for all remote hosts within the manager node...
# NOTE:  apparently if you don't get the server finger print and examine it to ensure 

# below was recommended from serverfault:
# ssh-keygen -R ["remote.node"]
# ssh-keygen -R ["192.168.34.51"]
# ssh-keygen -R ["remote.node"],["192.168.34.51"]
# ssh-keyscan -H ["remote.node"],["192.168.34.51"] >> ~/.ssh/known_hosts
# ssh-keyscan -H ["192.168.34.51"] >> ~/.ssh/known_hosts
# ssh-keyscan -H ["remote.node"] >> ~/.ssh/known_hosts

# ssh-keygen -R ["$6"]
# ssh-keygen -R ["$6"],[ip_address]
# ssh-keyscan -H ["$6"],[ip_address] >> ~/.ssh/known_hosts
# ssh-keyscan -H ["$6"] >> ~/.ssh/known_hosts
# sudo -u "$UAPPNAME" export SSHPASS="$SSHPASS"
# sudo -u "$UAPPNAME" sshpass -e ssh-copy-id "$UAPPNAME@$REMOTE_IP"



