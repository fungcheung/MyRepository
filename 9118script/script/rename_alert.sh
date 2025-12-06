#####################################################################
## chk_alert.sh ##
## Author: James
## Purpose: Rename alertlog and listener log. Perform an alert log check beforehand and to null the last alertlog 
##          because chk_alert.sh use the last alertlog to compare with the alertlog.
## Date: Aug 2016
#####################################################################

######## Oracle Enviorment variables ##########
cd ~/script
. ~/script/profile

alertcp=~/script/log/alert_${ORACLE_SID}.log
alertlast=~/script/log/alert_${ORACLE_SID}.log.last
alertdiff=~/script/log/alert_${ORACLE_SID}.diff
LOG=~/script/log/chk_alert.log
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/chk_alert_mailx.log

##
if [ -f $alertlog ]
then
  cp -p $alertlog $alertcp
  cp -p $alertlog ${alertlog}.${datevar}
  cat /dev/null > $alertlog
  cp -p $lsnrlog  ${lsnrlog}.${datevar}
  cat /dev/null > $lsnrlog
  diff $alertcp $alertlast > $alertdiff
  if [ `cat $alertdiff |egrep 'ORA-|Shut'|wc -l` -gt 0 ]
  then
    mailx -s "ORA- Errors in ${ORACLE_HOSTNAME} $datevar" $DBA < $alertdiff 2>&1 1>$mailxlog
    echo "ORA- Errors $datevar" >> $LOG
    echo ------------------------------------------------------------------------------ >> $LOG
    cat $alertdiff >> $LOG
  else
    echo "No ORA- or Shutdown errors $datevar" >> $LOG
  fi
  # Null the $alertlast so that next comparison is valid.
  cat /dev/null > $alertlast
fi
exit


