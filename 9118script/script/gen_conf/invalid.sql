spool invalid.log

set linesize 188 pages 999

col segment_name format a30

prompt =========================================================================================================================================================
column owner format a20
column object_type format a20
column object_name format a30


select owner,object_type,object_name,status from dba_objects where status = 'INVALID'
order by owner, object_type,object_name;



spool off