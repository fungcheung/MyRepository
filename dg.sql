-- Author: James Cheung
-- Last modified 4/2016
-- Monitor Oracle 12c data guard 

set pages 200 lines 200
set feed off
alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss' ;
alter session set nls_timestamp_format = 'dd-mm-yyyy hh24:mi:ss' ;
set feed on

prompt ===========================================================================================================
Prompt PDB info
column file# format 999,999
column name format a60
column open_mode format a25
column status format a25
select name, open_mode from v$pdbs;
select file#,name, status from v$datafile;
prompt


prompt ===========================================================================================================
Prompt DG info
column protection_mode format a25
column protection_level format a25
column role format a20
column switchover_status format a25
column open_mode format a15
SELECT PROTECTION_MODE, PROTECTION_LEVEL, DATABASE_ROLE ROLE, SWITCHOVER_STATUS, open_mode FROM V$DATABASE;
prompt

prompt ===========================================================================================================
Prompt Fast-start failover status(FSFO STATUS should be SYNCHRONIZED/TARGET UNDER LAG LIMIT before FSFO can occur)
column "FSFO STATUS" format a30
column TARGET format a20
column THRESHOLD format 999,999.99
column "OBSERVER PRESENT" format a20
column PENDING_ROLE_CHANGE_TASKS format a25
SELECT FS_FAILOVER_STATUS "FSFO STATUS", FS_FAILOVER_CURRENT_TARGET TARGET, 
FS_FAILOVER_THRESHOLD THRESHOLD, 
FS_FAILOVER_OBSERVER_PRESENT "OBSERVER PRESENT",
PENDING_ROLE_CHANGE_TASKS  
FROM V$DATABASE;
prompt

prompt ===========================================================================================================
prompt Archived dest,SCNs and Gap (Run in Primary only)
prompt The STATUS must be VALID and ERROR should be null in normal status
column applied_scn_time format a20
column current_scn_time format a20
column dest format a10
column error format a30
column name format a30
column value format a150
column status format a15
column gap_status format a20
column dest_name format a30
SELECT DEST_ID,STATUS,DESTINATION DEST,APPLIED_SCN, SCN_TO_TIMESTAMP(APPLIED_SCN) APPLIED_SCN_TIME, current_scn,SCN_TO_TIMESTAMP(current_scn) current_scn_time,ERROR
FROM V$ARCHIVE_DEST, v$database WHERE TARGET='STANDBY';
SELECT DEST_ID,STATUS, GAP_STATUS FROM V$ARCHIVE_DEST_STATUS WHERE DEST_ID = 2;
select name,value from v$parameter where name in ('log_archive_dest_1','log_archive_dest_2','log_archive_dest_state_1','log_archive_dest_state_2');
prompt Standby (recovery_mode should be "MANAGED REAL TIME APPLY")
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
prompt


prompt ===========================================================================================================
prompt Retrieve last 10 rows of archived logs (V$ARCHIVED_LOG)
prompt The SEQUENCE# should be the same in both database in normal status
select REGISTRAR,THREAD#, SEQUENCE#,APPLIED, FIRST_time, NEXT_time from 
(SELECT REGISTRAR,THREAD#, SEQUENCE#,APPLIED, FIRST_time, NEXT_time FROM V$ARCHIVED_LOG 
where registrar in ('RFS','ARCH','FGRD') order by first_time desc) 
where rownum < 11 order by first_time;
prompt

prompt ===========================================================================================================
Prompt Redo Apply and redo transport status (V$MANAGED_STANDBY)
prompt Primary LNS(ASYNC Redo Transport)/LGWR process 
prompt Standby RFS(Remote file server),MRP0(Detached recovery server) 

column status format a15
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#,BLOCK#, BLOCKS FROM V$MANAGED_STANDBY order by thread#,SEQUENCE# ;
prompt

prompt ===========================================================================================================
prompt Monitoring Apply Lag (Run in Standby only)
prompt "apply lag" = Time visible in standby - Time visible in Primary. Should be < 30s, or the metric is not accurate
column name format a25
column value format a30
column datum_time format a30
column time_computed format a30
SELECT name, value, datum_time, time_computed FROM V$DATAGUARD_STATS;
prompt


prompt ===========================================================================================================
prompt DG message(ERROR,FATAL) from V$DATAGUARD_STATUS of last 15 minutes
column FACILITY format a25
column SEVERITY format a10
column MESSAGE format a70
SELECT timestamp,FACILITY,SEVERITY,MESSAGE FROM V$DATAGUARD_STATUS 
where upper(SEVERITY) in ('ERROR','FATAL','WARNING') and round((cast(systimestamp as date) - cast(timestamp as date))* 24 * 60) < 15
 order by timestamp;
-- SELECT timestamp,FACILITY,SEVERITY,MESSAGE FROM V$DATAGUARD_STATUS 
-- where upper(SEVERITY) in ('ERROR','FATAL','WARNING') and timestamp > systimestamp-2 order by timestamp;
prompt

prompt ===========================================================================================================
prompt Last failover details (V$FS_FAILOVER_STATS)
column LAST_FAILOVER_TIME format a25
column LAST_FAILOVER_REASON format a70

SELECT LAST_FAILOVER_TIME, LAST_FAILOVER_REASON FROM V$FS_FAILOVER_STATS;

  
