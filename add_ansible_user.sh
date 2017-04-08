#!/bin/bash

UAPPNAME="$1"
UAPPNAMEPW="$2"
UUIDNUMBER=$3
DESCRIPTION="$4"


if [ ! "$(grep ^$UAPPNAME /etc/sudoers | grep -v grep)" ] ; then
	echo "Adding Sudo User:  $UAPPNAME"  && \
	/usr/sbin/groupadd -g $UUIDNUMBER $UAPPNAME && \

# local login requires a pass word...
# ubuntu box doesn't create home dir auto... add that option
	/usr/sbin/useradd -u $UUIDNUMBER -g $UUIDNUMBER -m -c "$DESCRIPTION" $UAPPNAME && \
	echo "$UAPPNAME:$UAPPNAMEPW" | chpasswd && \


    echo -e "$UAPPNAME\t\tALL=(ALL) NOPASSWD:ALL\t# $DESCRIPTION" >> /etc/sudoers
fi

# create the RSA key for the user...

if [ ! -f "/home/$UAPPNAME/.ssh/id_rsa.pub" ]; then
	if [ ! -d "/home/$UAPPNAME/.ssh" ]; then
		mkdir -p /home/$UAPPNAME/.ssh
 	fi
	ssh-keygen -b 2048 -t rsa -f "/home/$UAPPNAME/.ssh/id_rsa" -q -N "" -C "$DESCRIPTION"  && \
	chown $UAPPNAME:$UAPPNAME -R "/home/$UAPPNAME/.ssh" && \
	chmod 700 -R /home/$UAPPNAME/.ssh
fi
# mkdir /home/postgres/.ssh
# sudo ssh-keygen -b 2048 -t rsa -f /home/postgres/.ssh/id_rsa -q -N "" -C postgres
# sudo chown postgres:postgres -R /home/postgres/.ssh
# sudo chmod 700 -R /home/postgres/.ssh


# An ldap search against the uto managed ldap lee gets the uid and gid from here.
# just a note: 
# ldapsearch -x -h ldap1.asu.edu -b "dc=asu,dc=edu" "cn=$1" >> /tmp/$1