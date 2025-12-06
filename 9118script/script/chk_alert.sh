#####################################################################
## chk_alert.sh ##
## Author: James
## Purpose: Check ORA- error or Shutdown in alertlog
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
  mv $alertcp $alertlast
fi
exit


