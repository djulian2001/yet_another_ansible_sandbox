#!/bin/bash
: '
setup 2 nodes...
postgresql 2 nodes with streaming replications
source:
	https://www.youtube.com/watch?v=ldOPon17uYE
node1:
ip: 192.168.137.101

node2:
ip: 192.168.137.102

'

# if not the user postgres is made... make one
id postgres
uid=1000(postgres) gid=1000(postgres) groups=1000(postgres)

useradd postgres -u 1000