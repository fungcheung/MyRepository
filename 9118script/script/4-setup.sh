echo "##########################################"
echo "##### Step 15 of 18"
echo "##### Complete Data Guard configuration"
echo "##########################################"
echo "##### Add the databases to the broker " 
echo "##### configuration. " 
echo "##### create configuration 'DGCONFIG' as " 
echo "##### primary database is 'cdb1' connect  " 
echo "##### identifier is cdb1;" 
echo "##### add database 'cdb2' as connect " 
echo "##### identifier is cdb2;" 
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


dgmgrl <<EOF
connect sys/oracle@cdb1
create configuration 'DGCONFIG' as primary database is 'cdb1' connect identifier is cdb1;
add database 'cdb2' as connect identifier is cdb2;
enable configuration;
EOF
sqlplus sys/oracle@cdb1 as sysdba <<EOF
alter system set log_archive_dest_2='service=cdb2 async valid_for=(online_logfile,primary_role) db_unique_name=cdb2';
EOF


echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 16 of 18"
echo "##### Enabling Fast-Start Failover"
echo "##########################################"
echo "##### edit database cdb1 set property " 
echo "##### FastStartFailoverTarget=cdb2;"
echo "##### edit database cdb2 set property "
echo "##### FastStartFailoverTarget=cdb1;"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

dgmgrl <<EOF
connect sys/oracle@cdb1
edit database cdb1 set property FastStartFailoverTarget=cdb2;
edit database cdb2 set property FastStartFailoverTarget=cdb1;
enable fast_start failover;
EOF



echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 17 of 18"
echo "##### Using Active Data Guard."
echo "##########################################"
echo "##### edit database 'cdb2' set "
echo "##### state='apply-on';"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


dgmgrl<<EOF
connect sys/oracle@cdb2
edit database 'cdb2' set state='apply-off';
EOF
sqlplus sys/oracle@cdb2 as sysdba <<EOF
alter database open read only;
EOF
dgmgrl<<EOF
connect sys/oracle@cdb2
edit database 'cdb2' set state='apply-on';
EOF

echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 18 of 18"
echo "##### Starting the Observer."
echo "##########################################"
echo "##### start observer"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

echo "##########################################"
echo "DONT CLOSE THIS TERMINAL. OPEN A NEW ONE"
echo "TO CONTINUE WITH THE EXERCISES."
echo "##########################################"
dgmgrl <<EOF
connect sys/oracle@cdb1
start observer;
EOF



