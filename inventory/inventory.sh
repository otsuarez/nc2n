#!/bin/bash

#pwd
#DIR=group_vars
DIR=data
#SERVERS=$(cd group_vars ; ls -d *)
#SERVERS=$(cd ${DIR} ; ls -d *)" localhost"
SERVERS=$(cd ${DIR} ; ls -d *)
#echo "inventariooooo ----> $SERVERS"
IN='{
'
host=''
HOSTVARS=''
for i in $SERVERS;
do
	host=$host'"'$i'" : { "hosts" : ["'$i'"] },
	'
done
for i in $SERVERS;
do
	HOSTVARS=$HOSTVARS'"'$i'" : { "ansible_connection" : "local" },
	'
done

#HOSTS=$(echo $host | sed 's/,$//')
HOSTS=$host
HOSTVARS=$(echo $HOSTVARS | sed 's/,$//')
IN=$IN$HOSTS'
    "_meta" : {
       "hostvars" : {
    	'$HOSTVARS'
       }
    }
}'
echo $IN
#IN=$IN'
#echo ;echo '---'; echo 

OUT='{
    "vbox"   : {
        "hosts"   : [ "vbox"]
    },
    "_meta" : {
       "hostvars" : {
          "vbox"     : { "ansible_connection" : "local" }
       }
    }
}'
#echo $OUT
