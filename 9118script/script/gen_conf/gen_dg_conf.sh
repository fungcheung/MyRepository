#####################################################################
## gen_conf.sh ##
## Author: James
## Purpose: Generate database configuration and info
## Date: Aug 2016
#####################################################################
###!/bin/bash
##
. ~/script/profile
cd ~/script/gen_conf

ROLE=`~/script/dgrole.sh`
if [ "$ROLE" != "PRIMARY" ]
then
   echo "ERROR: Must run on PRIMARY database"
   exit 99
fi


datevar=`date '+%Y-%m-%d_%H%M%S'`
LOG=~/script/gen_conf/log/gen_conf_${datevar}.log
mailxlog=~/script/gen_conf/log/gen_conf_mailx.log
SQL=~/script/gen_conf/gen_conf.sql

sqlplus -s -L "/ as sysdba" < $SQL 2>&1 1>$LOG

if [ `cat $LOG|grep ORA-|wc -l` -gt 0 ]
then
mailx -s "Error: Failed to generate Configuration for ${PDB} in ${ORACLE_HOSTNAME} at $datevar" $DBA < $LOG  2>&1 1>$mailxlog
fi

mv *.log log

