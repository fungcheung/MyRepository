#!/bin/bash

if [ "$1" != "Y" ]
then
 echo "Usage: startup.sh Y"
 exit 99
fi

. ~/.bashrc
cd /home/oracle/script

# Start Listener
lsnrctl start

# Start Database
sqlplus / as sysdba <<EOF
STARTUP MOUNT;
@open_dg.sql
EXIT;
EOF

