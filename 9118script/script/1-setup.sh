#!/bin/sh
clear
echo "##########################################"
echo "##### Step 1 of 18"
echo "##### Enable FORCE LOGGING mode"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### We enable FORCE LOGGING mode."
echo "##### alter database force logging;"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

. oraenv <<EOF
cdb1
EOF
sqlplus "/ as sysdba" <<EOF
prompt alter database force logging;
alter database force logging;
EOF
echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 2 of 18"
echo "##### Add standby logfiles to the primary"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### Configure the primary database to" 
echo "##### receive redo data, by adding the "
echo "##### standby logfiles to the primary"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

. oraenv <<EOF
cdb1
EOF
sqlplus "/ as sysdba" <<EOF
prompt alter database add standby logfile '/u02/oradata/cdb1/srl01.log' size 50M;
alter database add standby logfile '/u02/oradata/cdb1/srl01.log' size 50M;
prompt alter database add standby logfile '/u02/oradata/cdb1/srl02.log' size 50M;
alter database add standby logfile '/u02/oradata/cdb1/srl02.log' size 50M;
prompt alter database add standby logfile '/u02/oradata/cdb1/srl03.log' size 50M;
alter database add standby logfile '/u02/oradata/cdb1/srl03.log' size 50M;
prompt alter database add standby logfile '/u02/oradata/cdb1/srl04.log' size 50M;
alter database add standby logfile '/u02/oradata/cdb1/srl04.log' size 50M;
EOF

echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 3 of 18"
echo "##### Set LOG_ARCHIVE* parameters"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### Set LOG_ARCHIVE_CONFIG and" 
echo "##### LOG_ARCHIVE_DEST_2 parameters. "
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

. oraenv <<EOF
cdb1
EOF
sqlplus "/ as sysdba" <<EOF
prompt alter system set log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST';
alter system set log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST';
prompt alter system set log_archive_config='dg_config=(cdb1,cdb2)';
alter system set log_archive_config='dg_config=(cdb1,cdb2)';
prompt alter system set log_archive_dest_2='service=cdb2 async valid_for=(online_logfile,primary_role) db_unique_name=cdb2';
alter system set log_archive_dest_2='service=cdb2 async valid_for=(online_logfile,primary_role) db_unique_name=cdb2';
prompt alter system set db_recovery_file_dest_size=5G;
alter system set db_recovery_file_dest_size=5G;
EOF

echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 4 of 18"
echo "##### ARCHIVELOG mode"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### Put the primary database in " 
echo "##### ARCHIVELOG mode to enable automatic"
echo "##### archiving."
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

export ORACLE_SID=cdb1
sqlplus "/ as sysdba" <<EOF
prompt shutdown immediate;
shutdown immediate;
prompt startup mount;
startup mount;
prompt alter database archivelog;
alter database archivelog;
prompt alter database open;
alter database open;
EOF

