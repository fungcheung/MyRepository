#####################################################################
## chk_conn.sh ##
## Author: James
## Purpose: Check GISP database is open and connection through listener is ok
## Date: Oct 2016
#####################################################################

######## Oracle Enviorment variables ##########
cd ~/script
. ~/script/profile

######## Enviorment variables ##########
SQL=~/script/chk_conn.sql
SQL2=~/script/chk_conn2.sql
LOG=~/script/log/conn.log
LOG2=~/script/log/conn2.log
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/chk_conn_mailx.log

ROLE=`~/script/dgrole.sh`
if [ "$ROLE" != "PRIMARY" ]
then
   echo "ERROR: Must run on PRIMARY database"
   exit 99
fi

### Check listener connection 
sqlplus -s -L $P1/$P2@$P3 < $SQL 2>&1 1>$LOG
if [ `cat $LOG|grep ORA-|wc -l` -ge 1 ]
then
echo Connection to ${DATABASE} failed at ${datevar} >> $LOG
mailx -s "Connection to ${DATABASE} in ${ORACLE_HOSTNAME} failed ${datevar}" $DBA < $LOG 2>&1 1>$mailxlog
else
echo Connection to ${DATABASE} in ${ORACLE_HOSTNAME} succeeded ${datevar} >> $LOG
fi

### Check GISP is in READ WRITE mode
sqlplus -s -L '/ as sysdba' < $SQL2 2>&1 1>$LOG2
if [ `cat $LOG2|grep "READ WRITE" |wc -l` -ne 1 ]
then
  echo Connection to GISP in ${ORACLE_HOSTNAME} failed ${datevar} >> $LOG2
  mailx -s "Connection to GISP in ${ORACLE_HOSTNAME} failed ${datevar}" $DBA < $LOG2 2>&1 1>$mailxlog
else
  echo Connection to GISP in ${ORACLE_HOSTNAME} succeeded ${datevar} >> $LOG2
fi

