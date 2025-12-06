#####################################################################
## chk_dg_tsp.sh ##
## Author: James
## Purpose: Check tablespace usage in DG environment and send out email if exceed threshold
## Date: Aug 2016
#####################################################################
###!/bin/bash
##
cd ~/script
. ~/script/profile

LOG=~/script/log/chk_dg_tsp.log
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/chk_dg_tsp_mailx.log
SQL=~/script/chk_tsp_${PDB}.sql

ROLE=`~/script/dgrole.sh`
if [ "$ROLE" != "PRIMARY" ]
then
   echo "ERROR: Must run on PRIMARY database"
   exit 99
fi

sqlplus -s -L "/ as sysdba" < $SQL 2>&1 1>$LOG

if [ `cat $LOG|wc -l` -gt 0 ]
then
mailx -s "Tablespace exceeds threshold for ${PDB} in ${ORACLE_HOSTNAME} at $datevar" $DBA < $LOG  2>&1 1>$mailxlog
fi

