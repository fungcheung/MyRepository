echo "##########################################"
echo "##### Step 11 of 18"
echo "##### Start Data Guard Broker on cdb1"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### alter system set dg_broker_start= " 
echo "##### true " 
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


sqlplus sys/oracle@cdb1 as sysdba <<EOF
prompt alter system set dg_broker_start=true;
alter system set dg_broker_start=true;
EOF
echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 12 of 18"
echo "##### Start Data Guard Broker on cdb2"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### alter system set dg_broker_start= " 
echo "##### true " 
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

sqlplus sys/oracle@cdb2 as sysdba <<EOF
prompt alter system set dg_broker_start=true;
alter system set dg_broker_start=true;
EOF
echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 13 of 18"
echo "##### Enable Database Flashback on cdb1"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

sqlplus sys/oracle@cdb1 as sysdba <<EOF
prompt shutdown immediate;
shutdown immediate;
prompt startup mount;
startup mount;
prompt alter database flashback on;
alter database flashback on;
prompt alter database open;
alter database open;
EOF
echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 14 of 18"
echo "##### Enable Database Flashback on cdb2"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


sqlplus sys/oracle@cdb2 as sysdba <<EOF
prompt shutdown immediate;
shutdown immediate;
prompt startup mount;
startup mount;
prompt alter database flashback on;
alter database flashback on;
prompt alter database open read only;
alter database open read only;
EOF

sqlplus sys/oracle@cdb1 as sysdba <<EOF
alter system set log_archive_dest_2='';
EOF

sqlplus sys/oracle@cdb2 as sysdba <<EOF
alter system set log_archive_dest_2='';

