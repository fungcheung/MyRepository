#!/bin/bash

if [ "$1" != "Y" ]
then
 echo "Usage: shutdown.sh Y"
 exit 99
fi

. ~/.bashrc

# Stop Listener
lsnrctl stop

# Stop Database
sqlplus / as sysdba << EOF
SHUTDOWN IMMEDIATE;
EXIT;
EOF


