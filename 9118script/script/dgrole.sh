#####################################################################
## dgrole.sh ##
## Author: James
## Purpose: return the database role of DG environment
## Date: Aug 2016
#####################################################################
###!/bin/bash
##
cd ~/script
. ~/script/profile

LOG=~/script/log/dgrole.log
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/dgrole_mailx.log
SQL=~/script/dgrole.sql

sqlplus -s -L "/ as sysdba" < $SQL 2>&1 1>$LOG

if [ `cat $LOG|egrep -i primary|wc -l` -gt 0 ]
then
   echo PRIMARY
fi

if [ `cat $LOG|egrep -i standby |wc -l` -gt 0 ]
then
   echo STANDBY
fi

