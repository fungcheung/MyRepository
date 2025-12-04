-- fiilename: show_jobs.sql

col SCHEMA_USER for a15
col job         for 9999
col INTERVAL    for a20
col failures    for 9999 head "Fails"

set lines 222 pages 999

spool c:\temp\show_jobs.spo

select SCHEMA_USER, job, substr(what, 1,40), broken, failures, LAST_DATE, NEXT_DATE , INTERVAL
from dba_jobs 
order by 1,2,3
/

spool off

prompt 
prompt host write c:\temp\show_jobs.spo
prompt 
prompt 

