prompt This script will display the current undo allocation in the db 
prompt It will show it at an extent level 

column segment_name format a20 
column tablespace_name format a15 
compute sum of "Extent Count" on report 
compute sum of "Total Blocks" on report 
break on report 

select segment_name, 
tablespace_name, 
count(extent_id) "Extent Count", 
status, 
sum(blocks) "Total Blocks" 
from dba_undo_extents 
group by segment_name, tablespace_name, status 
order by segment_name 
/


prompt This query will display the UNDO statistics. It shows the number 
prompt of ORA-1555s, the longest query time, and (Un)Expired Steals (SC). 
prompt The "steal" values are the number of requests for steals, not 
prompt the actual number of blocks stolen (not reported in this query). 
prompt When the UNExp SC is > 0, that indicates a UNDO space issue. 

select to_char(begin_time, 'mm/dd/yyyy hh24:mi') "Int. Start", 
ssolderrcnt "ORA-1555s", 
maxquerylen "Max Query", 
unxpstealcnt "UNExp SC", 
expstealcnt "Exp SC" 
from v$undostat 
order by begin_time 
/


select (rd*(ups*overhead) + overhead) as "Bytes" 
from 
(select value as RD from v$parameter 
where name= 'undo_retention'), 
(select (SUM(undoblks) / SUM( ((end_time - begin_time) * 86400))) as UPS from v$undostat), 
(select value AS overhead from v$parameter 
where name= 'db_block_size'); 

