#!/bin/bash
: '
build a database using postgresql replication with repmgr and pgbouncer
vid source:
	https://www.youtube.com/watch?v=wgp_7hzelEc
git source:
	https://github.com/N3TC4T/tutorials/tree/master/postgresql_repmgr_pgbouncer
	
'
# master

yum install -y http://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

yum install -y postgresql96 postgresql96-contrib postgresql96-server repmgr96

export PATH=$PATH:/usr/pgsql-9.6/bin
ln -s /usr/pgsql-9.6/bin/* /usr/local/bin/

postgresql96-setup initdb

# config postgre.conf 
	listen_addresses = '*'  # too open
	# listen_addresses = '192.168.1.0/24' # use a cidr for the subnet
	wal_level = hot_standby
	wal_log_hints = on
	archive_mode = on
	archive_command = '/bin/true'
	# archive_command = '/bin/cp -i %p /opt/data %f'
# config pg_hba.conf

systemctl start postgresql-9.6


# config /etc/repmgr.conf on all nodes



su - postgres 

createuser -s repmgr
createdb repmgr -O repmgr
repmgr -f /etc/repmgr.conf master register

psql 

CREATE role manager LOGIN PASSWORD 'manager_password' SUPERUSER;
CREATE USER user_test WITH PASSWORD 'user_password';
CREATE DATABASE test_db;
GRANT ALL PRIVILEGES ON DATABASE test_db to user_test;

\q


----

su - postgres

repmgr -h p1 -U repmgr -d repmgr -D /var/lib/pgsql/9.6/data/ -f /etc/repmgr.conf standby clone
sudo systemctl start postgresql-9.6
repmgr standby register

# for verify
psql -U repmgr repmgr
select * from repmgr_cluster1.repl_nodes;

# run repmgrd just on slaves
repmgrd -m -d -p /var/run/repmgrd.pid -f /etc/repmgr.conf --verbose >> $HOME/repmgr/repmgr.log 2>&1
ps aux | grep repmgrd

# for status
psql -U repmgr repmgr
select * from repmgr_cluster1.repl_status ;


------------------------------------------------------------------------------------
# after faild master , convert to slave
# rm -rf /data

# clone 
repmgr -h p2 -U repmgr -d repmgr -D /var/lib/pgsql/9.6/data/ -f /etc/repmgr.conf standby clone --force

# reigster as standby
repmgr standby register --force

# run repmgrd
repmgrd -d -p /var/run/repmgrd -f /etc/repmgr.conf --verbose >> $HOME/repmgr/repmgr.log 2>&1


-------------------------------------------------------------------------------------

# for switching an slave to master 

# kill repmgrd on all slaves
killall -9 repmgrd

# on salve to be promoted
repmgr -f /etc/repmgr.conf -C /etc/repmgr.conf standby switchover -v




yum install pgbouncer -y 

# set /etc/pgbouncer/pgbouncer.ini
# set /etc/pgbouncer/pgbouncer.database.ino
# set /etc/pgbouncer/userlist.txt

systemctl start pgbouncer

user=manager; passw=manager_password; echo -n md5; echo $passwd$user | md5sum
user=user_test; passw=user_password; echo -n md5; echo $passwd$user | md5sum