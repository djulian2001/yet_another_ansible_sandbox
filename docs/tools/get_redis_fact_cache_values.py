import redis
import json

r = redis.StrictRedis( host='localhost', port=6379, db=0 )
key = "ansible_facts"+"[host_name]"
var = r.get( key )
data = json.loads( var )
print data['ansible_memfree_mb']

# source: http://jpmens.net/2015/01/29/caching-facts-in-ansible/