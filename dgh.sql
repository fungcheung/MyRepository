-- Author: James Cheung
-- Last modified 4/2016
-- Monitor Oracle 12c data guard 
-- Base DG health check


set pages 200 lines 200
set feed off
alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss' ;
alter session set nls_timestamp_format = 'dd-mm-yyyy hh24:mi:ss' ;
set feed off

prompt Checklist: Switchover_status, open_mode
column protection_mode format a25
column protection_level format a25
column role format a20
column switchover_status format a25
column open_mode format a15
SELECT PROTECTION_LEVEL, DATABASE_ROLE ROLE, SWITCHOVER_STATUS, open_mode FROM V$DATABASE;
prompt

Prompt Checklist: FSFO STATUS = SYNCHRONIZED/TARGET UNDER LAG LIMIT before FSFO can occur
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

prompt Checklist: V$ARCHIVE_DEST_STATUS Primary(STATUS=VALID,VALUE=ENABLE), Standby(STATUS=INACTIVE,VALUE=ENABLE)
prompt Checklist: log_archive_dest_2 null in standby
column name format a30
column value format a10
column status format a15
column gap_status format a20
SELECT distinct DEST_ID,STATUS, GAP_STATUS,value FROM V$ARCHIVE_DEST_STATUS, v$parameter WHERE DEST_ID = 2 and name in ('log_archive_dest_state_2');
column value format a190
select value as log_archive_dest_2 from v$parameter where name in ('log_archive_dest_2');
prompt


Prompt Checklist: Redo Apply and redo transport (V$MANAGED_STANDBY) Primary(LNS/LGWR) Standby(MRP0)
column status format a15
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#,BLOCK#, BLOCKS FROM
(select PROCESS, STATUS, THREAD#, SEQUENCE#,BLOCK#, BLOCKS FROM V$MANAGED_STANDBY order by resetlog_id desc, SEQUENCE# desc)
where rownum < 3 order by thread#,SEQUENCE# ;
prompt


