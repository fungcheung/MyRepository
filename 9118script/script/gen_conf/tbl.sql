spool tbl.log

set linesize 188 pages 999

col segment_name format a30
col owner format a15
col segment_type format a15
col tablespace_name format a15



prompt =========================================================================================================================================================
prompt Show tables and indexes of all users > 10M


break on owner

select owner, segment_name, segment_type, BYTES/1024/1024 Size_M ,tablespace_name from dba_segments 
where bytes/1024/1024 > 10 and owner not in ('SYS','SYSTEM') and segment_name not like '%BIN$%' 
order by owner,segment_type desc,Size_M desc ;

spool off