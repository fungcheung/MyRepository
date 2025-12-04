
@setting
spool c:\temp\show_fts.spo

Column sql_text Format A111 Heading 'Full Table Scans' Wrap 
break on sql_text skip 1 

Select Executions, Sorts, Disk_Reads, Buffer_Gets, CPU_Time, Elapsed_Time, sql_text 
from v$sqlarea 
where (address, hash_value) in 
  (Select address, hash_value from v$sql_plan   
    where options   like '%FULL%' and operation like '%TABLE%') 
Order by Elapsed_Time 
/ 

spool off 

prompt 
prompt host write c:\temp\show_fts.spo
prompt 
prompt 
