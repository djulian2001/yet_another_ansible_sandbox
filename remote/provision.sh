#!/bin/bash

yum update -y

# Change the bass ssh config file...
# config file:	/etc/ssh/sshd_config
# option:  		PasswordAuthentication from no to yes;
#PasswordAuthentication yes
#PasswordAuthentication no
# restart service 
TARGET_KEY="PasswordAuthentication"
REPLACEMENT_VALUE="yes"
CONFIG_FILE="/etc/ssh/sshd_config"
TEST_CONFIG_SET="$TARGET_KEY $REPLACEMENT_VALUE"

if [ ! "$(grep ^TEST_CONFIG_SET $CONFIG_FILE | grep -v grep)" ] ; then
	sed --copy --in-place "s/\($TARGET_KEY * *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE 
	service sshd restart
fi

# init the ansible user(s)
# the use of args probably should be replaced with a config file
/bin/bash /vagrant/add_ansible_user.sh "$1" "$2" $3 "$4"

