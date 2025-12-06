#####################################################################
## chk_mntpt.sh ##
## Author: James
## Purpose: Check mount point space usage and send mail if exceed THRESHOLD
## Date: Aug 2016
#####################################################################
#!/bin/ksh

######## Oracle Enviorment variables ##########
cd ~/script
. ~/script/profile

LOG=~/script/log/chk_mntpt.log
THRESHOLD=80
WARNING=0
datevar=`date '+%Y-%m-%d_%H%M%S'`
mailxlog=~/script/log/chk_mntpt_mailx.log

echo "df -m output for `date` `uname -n`" > $LOG
echo " " >> $LOG
echo "File system usage exceeds threshold(${THRESHOLD}%) on `uname -n` server- `date`" >> $LOG
i=1
while [ $i -le `df -m | grep -v Filesystem | wc -l` ] ;do
if [ `df -m | grep -v Filesystem | head -n $i | tail -1 | awk '{print $5}' | sed -e 's/%//'` -gt $THRESHOLD ] ; then
df -m | grep -v Filesystem | head -n $i | tail -1 >> $LOG
WARNING=1
fi
((i=i+1))
done
if [ $WARNING -gt 0 ] ; then
mailx -s "File system usage exceeds threshold(${THRESHOLD}%) in ${ORACLE_HOSTNAME} at $datevar" $DBA < $LOG 2>&1 1>$mailxlog
else
exit
fi

