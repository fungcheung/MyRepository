#####################################################################
## gen_awr.sh ##
## Author: James
## Purpose: Generate awr rpts
## Date: Aug 2016
#####################################################################
###!/bin/bash
##
. ~/script/profile
cd ~/script/gen_awr

ROLE=`~/script/dgrole.sh`
if [ "$ROLE" != "PRIMARY" ]
then
   echo "ERROR: Must run on PRIMARY database"
   exit 99
fi


datevar=`date '+%Y-%m-%d_%H%M%S'`
LOG1=~/script/gen_awr/log/gen_awr_${datevar}.html
LOG2=~/script/gen_awr/log/gen_addm_${datevar}.html
mailxlog=~/script/gen_awr/log/gen_awr_mailx.log
SQL1=~/script/gen_awr/gen_awr.sql
SQL2=~/script/gen_awr/gen_addm.sql
LOGDIR=~/script/gen_awr/log


# The echo is used to avoid needing to press CTRL-D when using mailx with -a option
sqlplus -s -L "/ as sysdba" < $SQL1 2>&1 1>$LOG1
echo|mailx -s "AWR for ${PDB} in ${ORACLE_HOSTNAME} at $datevar" -a $LOG1 $DBA  2>&1 1>$mailxlog

sqlplus -s -L "/ as sysdba" < $SQL2 2>&1 1>$LOG2
echo|mailx -s "ADDM for ${PDB} in ${ORACLE_HOSTNAME} at $datevar" -a $LOG2 $DBA  2>&1 1>$mailxlog

# Delete awr/addm reports older than 365 days
find $LOGDIR -mtime +365 -exec rm {} \;
