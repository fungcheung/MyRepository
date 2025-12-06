-- Author: James Cheung
-- Last modified 4/2016
-- Monitor Oracle 12c data guard 

set pages 200 lines 200
set head off
set feed off
column file# format 999,999
column name format a60
column open_mode format a25
column status format a25

SELECT 'DATABASE_ROLE:' || DATABASE_ROLE FROM V$DATABASE;
SELECT 'OPEN_MODE:' || OPEN_MODE FROM V$DATABASE;
select 'RECOVERY_MODE:' || RECOVERY_MODE from v$archive_dest_status where dest_id=1;
select name || ':' || open_mode from v$pdbs;
SELECT 'FS_FAILOVER_STATUS:' || FS_FAILOVER_STATUS FROM V$DATABASE;
SELECT 'OBSERVER_PRESENT:' || FS_FAILOVER_OBSERVER_PRESENT FROM V$DATABASE;
SELECT 'GAP_STATUS:' ||  GAP_STATUS FROM V$ARCHIVE_DEST_STATUS WHERE DEST_ID = 2;
SELECT 'TRANSPORT_LAG:' || value FROM V$DATAGUARD_STATS where upper(name)='TRANSPORT LAG';
SELECT 'APPLY_LAG:' || value FROM V$DATAGUARD_STATS where upper(name)='APPLY LAG';
SELECT 'APPLY_FINISH_TIME:' || value FROM V$DATAGUARD_STATS where upper(name)='APPLY FINISH TIME';

select file#,name, status from v$datafile;
select ' ' from dual;

exit

 
