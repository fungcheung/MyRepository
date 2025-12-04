col ownr format a20         justify c heading 'Owner' 
col name format a20         justify c heading 'Tablespace' trunc 
col qota format a12         justify c heading 'Quota (KB)' 
col used format 999,999,990 justify c heading 'Used (KB)' 
 
break on ownr skip 1 
 
select 
  username          ownr, 
  tablespace_name   name, 
  decode(greatest(max_bytes, -1), 
    -1, 'Unrestricted', 
    to_char(max_bytes/1024, '999,999,990') 
  )                 qota, 
  bytes/1024        used 
from 
  dba_ts_quotas 
where 
  max_bytes!=0 
    or 
  bytes!=0 
order by 
  1,2 
/ 
 
