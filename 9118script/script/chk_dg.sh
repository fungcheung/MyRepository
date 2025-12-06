#####################################################################
## chk_dg ##
## Author: James
## Purpose: DG environment healthy
## Date: Oct 2016
#####################################################################

######## Oracle Enviorment variables ##########
cd ~/script
. ~/script/profile

######## Enviorment variables ##########
SQL=~/script/chk_dg.sql
LOG=~/script/log/chk_dg.log
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/chk_dg_mailx.log
ERROR=0
APPLY_FINISH_TIME_THRESHOLD_IN_MIN=5
nomail=0

while [ $# -gt 0 ]
do
  case $1 in
    -nomail)
      nomail=1
    ;;
    *)
    ;;
  esac
  shift
done

### DGMGRL health check
dgmgrl > $$.log <<EOF
connect /
show configuration verbose
show database verbose cdb1
show database verbose cdb2
SHOW DATABASE cdb1 'LogXptStatus';
SHOW DATABASE cdb1 'InconsistentLogXptProps';
SHOW DATABASE cdb1 'InconsistentProperties';
EOF


if [ `cat $$.log | egrep -i 'warning|error' | wc -l` -gt 0 ]
then
  ERROR=1
fi

sqlplus -s -L / as sysdba < $SQL 2>&1 1>$LOG

OPEN_MODE=`cat $LOG|egrep -i OPEN_MODE | cut -f2 -d:`
RECOVERY_MODE=`cat $LOG|egrep -i RECOVERY_MODE | cut -f2 -d:`
GISP_MODE=`cat $LOG|grep GISP | cut -f2 -d:`
FS_FAILOVER_STATUS=`cat $LOG|egrep -i FS_FAILOVER_STATUS | cut -f2 -d:`
OBSERVER_PRESENT=`cat $LOG|egrep -i OBSERVER_PRESENT | cut -f2 -d:`
GAP_STATUS=`cat $LOG|egrep -i GAP_STATUS | cut -f2 -d:`
TRANSPORT_LAG=`cat $LOG|egrep -i TRANSPORT_LAG | cut -f2 -d+ | cut -f2 -d:`
APPLY_LAG=`cat $LOG|egrep -i APPLY_LAG | cut -f2 -d+ | cut -f2 -d:`
APPLY_FINISH_TIME=`cat $LOG|egrep -i APPLY_FINISH_TIME | cut -f2 -d+ | cut -f2 -d:`

 
ROLE=`~/script/dgrole.sh`
if [ "$ROLE" = "PRIMARY" ]
then
  if [ "$OPEN_MODE" != "READ WRITE" ]
  then 
    ERROR=1 
    echo ERROR: OPEN_MODE != "READ WRITE" >> $LOG
  fi
  if [ "$GISP_MODE" != "READ WRITE" ]
  then 
    ERROR=1 
    echo ERROR: GISP_MODE != "READ WRITE" >> $LOG
  fi
  if [ "$FS_FAILOVER_STATUS" != "SYNCHRONIZED" ]
  then 
    ERROR=1 
    echo ERROR: FS_FAILOVER_STATUS != "SYNCHRONIZED" >> $LOG
 fi
  if [ "$OBSERVER_PRESENT" != "YES" ]
  then 
    ERROR=1 
    echo ERROR: OBSERVER_PRESENT != "YES" >> $LOG
  fi
  if [ "$GAP_STATUS" != "NO GAP" ]
  then 
    ERROR=1 
    echo ERROR: GAP_STATUS != "NO GAP" >> $LOG
  fi
else
  if [ "$OPEN_MODE" != "MOUNTED" ] 
  then 
    ERROR=1 
    echo ERROR: OPEN_MODE != "MOUNTED" >> $LOG
  fi
  if [ "$GISP_MODE" != "MOUNTED" ] 
  then 
    ERROR=1 
    echo ERROR: GISP_MODE != "MOUNTED" >> $LOG
  fi
  if [ "$FS_FAILOVER_STATUS" != "SYNCHRONIZED" ] 
  then 
    ERROR=1 
    echo ERROR: FS_FAILOVER_STATUS != "SYNCHRONIZED" >> $LOG
  fi
  if [ "$OBSERVER_PRESENT" != "YES" ] 
  then 
    ERROR=1 
    echo ERROR: OBSERVER_PRESENT != "YES" >> $LOG
  fi
  if [ `echo $APPLY_FINISH_TIME | bc` -ge $APPLY_FINISH_TIME_THRESHOLD_IN_MIN ]
  then 
    ERROR=1
    echo ERROR: APPLY_FINISH_TIME_THRESHOLD_IN_MIN >= $APPLY_FINISH_TIME_THRESHOLD_IN_MIN >> $LOG
  fi
fi

if [ $ERROR -eq 1 ]
then
  echo ' ' >> $LOG 
  cat $$.log >> $LOG
  if [ $nomail -eq 0 ]
  then
    mailx -s "DG healthcheck in ${ORACLE_HOSTNAME} failed ${datevar}" $DBA < $LOG 2>&1 1>$mailxlog
  fi

fi

rm $$.log

