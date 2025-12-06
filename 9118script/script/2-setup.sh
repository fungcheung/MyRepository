
export ORACLE_SID=cdb1
echo "##########################################"
echo "##### Step 5 of 18"
echo "##### Backup database"
echo "##########################################"
echo "##### RMAN"
echo "##### backup database plus archivelog"
echo "##### Create a copy of the primary " 
echo "##### database using RMAN."
echo "##### THIS COULD TAKE SEVERAL MINUTES"
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


rman<<EOF

connect target / 

backup database plus archivelog;

EOF

echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 6 of 18"
echo "##### Start the instance cdb2"
echo "##########################################"
echo "##### sqlplus / as sysdba"
echo "##### Create the needed folders and " 
echo "##### start the database in nomount."
echo "##### Copying the password file."
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read

ssh oracle@dg2 touch /u01/app/oracle/product/12.1.0.2/db_1/dbs/initcdb2.ora
ssh oracle@dg2 'echo "DB_NAME=cdb2" >> /u01/app/oracle/product/12.1.0.2/db_1/dbs/initcdb2.ora'


ssh oracle@dg2 mkdir /u01/app/oracle/admin/cdb2
ssh oracle@dg2 mkdir /u01/app/oracle/admin/cdb2/adump
ssh oracle@dg2 mkdir /u01/app/oracle/admin/cdb2/dpdump
ssh oracle@dg2 mkdir /u01/app/oracle/admin/cdb2/pfile

ssh oracle@dg2 mkdir /u02/oradata/cdb2
ssh oracle@dg2 mkdir /u02/fast_recovery_area/cdb2
ssh oracle@dg2 mkdir /u02/fast_recovery_area/CDB2
ssh oracle@dg2 mkdir /u02/oradata/cdb2/gisp
ssh oracle@dg2 mkdir /u02/oradata/cdb2/pdbseed
ssh oracle@dg2 chmod -R 777 /u02/oradata/cdb2
ssh oracle@dg2 chmod -R 777 /u02/fast_recovery_area/cdb2
ssh oracle@dg2 chmod -R 777 /u02/fast_recovery_area/CDB2

export ORACLE_SID=cdb2
echo "cp orapworcl orapworclstby"
ssh oracle@dg2 cp /u01/app/oracle/product/12.1.0.2/db_1/dbs/orapwcdb1 /u01/app/oracle/product/12.1.0.2/db_1/dbs/orapwcdb2
echo "Pls in dg2, startup nomount pfile=/u01/app/oracle/product/12.1.0.2/db_1/dbs/initcdb2.ora"

echo "Press ENTER to continue"
read
clear
echo "##########################################"
echo "##### Step 7 of 18"
echo "##### RMAN - Create standby database"
echo "##########################################"
echo "##### On the primary datbase, invoke"
echo "##### RMAN and connect to the standby. " 
echo "##### When this script finishes you will "
echo "##### have a new standby database."
echo "##########################################"
echo ""
echo "In order to continue press ENTER"
read


export ORACLE_SID=cdb1
rman<<EOF

connect target sys/oracle
connect auxiliary sys/oracle@cdb2 
@rman.txt

EOF
echo "Press ENTER to continue"
read
clear
