dgmgrl > a.log <<EOF
connect sys/oracle
show configuration
show database cdb1
show database cdb2
SHOW DATABASE cdb1 'LogXptStatus';
SHOW DATABASE cdb1 'InconsistentLogXptProps';
SHOW DATABASE cdb1 'InconsistentProperties';
EOF

echo "No warning or error output is good"
egrep -i 'warning|error' a.log

