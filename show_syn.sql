-- fiilename: show_syn.sql

set lines 222

select
OWNER, TABLE_OWNER, count(*)
from dba_synonyms
group by OWNER, TABLE_OWNER
order by OWNER, TABLE_OWNER
/

set lines 99

