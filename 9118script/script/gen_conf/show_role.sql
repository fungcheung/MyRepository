spool show_role.log

set lines 222

select * from dba_roles
order by 1 ;

set lines 99

prompt
prompt

spool off