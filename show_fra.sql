-- Filename: show_fra.sql

alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss' ;

set linesize 140
column sql_text format a90 wrap
column username format a12 wrap
column sid format 9999
column module format a12
break on sid skip 1

-- What Flashback options are currently enabled for this database?
TTITLE 'Flashback Options Currently Enabled:'
COL name                FORMAT A32      HEADING 'Parameter'
COL value               FORMAT A32      HEADING 'Setting'

SELECT  name ,value
  FROM v$parameter 
 WHERE NAME LIKE '%flash%' OR NAME LIKE '%recovery%'
 ORDER BY NAME;

-- What's the status of the Flash Recovery Area?
TTITLE 'Flash Recovery Area Status'
COL name                FORMAT A32      HEADING 'File Name'
COL spc_lmt_mb          FORMAT 9,999,999.99  HEADING 'Space|Limit|(MB)'
COL spc_usd_mb          FORMAT 9,999,999.99  HEADING 'Space|Used|(MB)'
COL spc_rcl_mb          FORMAT 9,999,999.99  HEADING 'Reclm|Space|(MB)'
COL number_of_files     FORMAT 99999    HEADING 'Files'

SELECT name ,space_limit /(1024*1024) spc_lmt_mb ,space_used /(1024*1024) spc_usd_mb 
            ,space_reclaimable /(1024*1024) spc_rcl_mb ,number_of_files
  FROM v$recovery_file_dest;


select * from v$recovery_area_usage;

column deleted format a7
column reclaimable format a11
set linesize 140
select applied,deleted,backup_count
 ,decode(rectype,11,'YES','NO') reclaimable,count(*)
 ,to_char(min(completion_time),'dd-mon hh24:mi') first_time
 ,to_char(max(completion_time),'dd-mon hh24:mi') last_time
 ,min(sequence#) first_seq,max(sequence#) last_seq
from v$archived_log a, sys.x$kccagf b, v$database c 
where is_recovery_dest_file='YES' and
a.recid=b.recid and
a.activation#=c .activation# 
group by applied,deleted,backup_count,decode(rectype,11,'YES','NO') order by min(sequence#)
/


  
-- Is Flashback Database currently activated for this database?
TTITLE 'Is Flashback Database Enabled?'
COL name                FORMAT A12                       HEADING 'Database'
COL current_scn         FORMAT 999,999,999,999,999,999   HEADING 'Current|SCN #'
COL flashback_on        FORMAT A8                        HEADING 'Flash|Back On?'

SELECT name ,current_scn ,flashback_on
  FROM v$database;

-- What's the earliest point to which this database can be flashed back?
TTITLE 'Flashback Database Limits'
COL oldest_flashback_scn     FORMAT 999999999999 HEADING 'Oldest|Flashback|SCN #'
COL oldest_flashback_time    FORMAT A20       HEADING 'Oldest|Flashback|Time'
COL retention_target         FORMAT 99999999999 HEADING 'Retention|Target'
COL flashback_size           FORMAT 99999999999999 HEADING 'Oldest|Flashback|Size'
COL estimated_flashback_size FORMAT 99999999999999 HEADING 'Estimated|Flashback|Size'

SELECT oldest_flashback_scn ,oldest_flashback_time ,retention_target 
      ,flashback_size ,estimated_flashback_size
  FROM v$flashback_database_log;

-- What Flashback Logs are available?
TTITLE 'Current Flashback Logs Available'
COL log#                FORMAT 9999     HEADING 'FLB|Log#'
COL bytes               FORMAT 9999999999 HEADING 'Flshbck|Log Size'
COL first_change#       FORMAT 9999999999999 HEADING 'Flshbck|SCN #'
COL first_time          FORMAT A24      HEADING 'Flashback Start Time'

SELECT  LOG# ,bytes ,first_change# ,first_time
  FROM v$flashback_database_logfile order by first_time;


clear break 
ttitle off

