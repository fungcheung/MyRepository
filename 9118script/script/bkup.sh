. ~/.bashrc
export PGPATH=/home/oracle/script
dt=`date '+%Y%m%d_%H%M%S'`
datevar=`date '+%Y-%m-%d_%H%M%S'`
LOG=$PGPATH/log/bkup_$dt.log
mailxlog=~/script/log/bkup_mailx.log

rman cmdfile=$PGPATH/bkup.rcv 1> $LOG 2>&1 

if [ `cat $LOG | egrep -i 'RMAN-' | wc -l` -gt 0 ]
then
  mailx -s "RMAN backup in ${ORACLE_HOSTNAME} failed ${datevar}" $DBA < $LOG2 2>&1 1>$mailxlog
fi

