-- fiilename: show_audit.sql

spool c:\temp\show_audit.spo

clear scr

select 'Connect: '||user||' \ '||instance_name||' \ '||host_name||' \ '||version from v$instance
union all
select 'Uptime : '||floor(xx)||'days '||floor((xx-floor(xx))*24)||'hours '||round(((xx-floor(xx )*24)-floor((xx-floor(xx)*24)))*60)||'minutes'||chr(10)||' ' "Database Uptime" 
from (select host_name,instance_name ,(sysdate-STARTUP_TIME) xx from v$instance)  ;


col user_name for a12 heading "User name"
col proxy_name for a12 heading "Proxy name"
col privilege for a30 heading "Privilege"
col user_name for a12 heading "User name" 
col audit_option format a30 heading "Audit Option"
col timest format a13 
col userid format a8 trunc 
col obn format a10 trunc 
col name format a13 trunc 
col sessionid format 99999 
col entryid format 999 
col owner format a10 
col object_name format a10 
col object_type format a6 
col priv_used format a15 trunc 
break on user_name
set pages 1000

select * from sys.dba_stmt_audit_opts
order by user_name, proxy_name, audit_option 
/


pause Press return to see audit trail... 
 
col owner       for a11
col user_name   for a11
col object_name for a33
set lines 122 verify off doc off

undef owner1

SELECT * from DBA_OBJ_AUDIT_OPTS
where owner = upper('&&owner1') 
and alt !='-/-' or aud !='-/-' or com !='-/-' 
 or del !='-/-' or gra !='-/-' or ind !='-/-' 
 or ins !='-/-' or loc !='-/-' or ren !='-/-' 
 or sel !='-/-' or upd !='-/-' or ref !='-/-' or exe !='-/-' ;

SELECT * from DBA_STMT_AUDIT_OPTS 
where USER_NAME = upper('&&owner1') ;


undef owner1

prompt
prompt SELECT * from DBA_STMT_AUDIT_OPTS 
prompt where USER_NAME not in ('SYSTEM','SYS')
prompt order by 1,2
prompt SELECT * from DBA_OBJ_AUDIT_OPTS 
prompt where owner not in ('SYSTEM','SYS')
prompt order by 1,3,2
prompt

col acname format a12 heading "Action name" 
select username userid, to_char(timestamp,'dd-mon hh24:mi') timest , 
  action_name acname, priv_used, obj_name obn, ses_actions 
from sys.dba_audit_trail 
where username like '%JAMES%'
order by timestamp 
/ 


select * from dba_priv_audit_opts
order by user_name, proxy_name, privilege
/



doc
-- audit session 
select 
   os_username, username, terminal, 
   decode(returncode,'0','Connected', '1005','FailedNull', '1017','Failed',returncode),
   to_char(timestamp,'DD-MON-YY HH24:MI:SS'),
   to_char(logoff_time,'DD-MON-YY HH24:MI:SS')
from dba_audit_session

select
   os_username, username, terminal,	owner, obj_name, action_name,
   decode(returncode,'0','Success', returncode),
   to_char(timestamp,'DD-MON-YY HH24:MI:SS')
from dba_audit_object

column	descrip	format a20	heading "Type"
column	num	format 999,990	heading "Number set"
break on report skip 1
compute sum of num on report
select 'Users' descrip,  count(*) num
  from sys.user$
 where audit$ is not null
union all
select  'Tables' descrip,  count(*) num
  from sys.tab$
 where ltrim(audit$,'-') is not null
union all
select 'Views' 	descrip, count(*) num
  from 
 where ltrim(audit$,'-') is not null
union all
select 'Sequences' descrip,  count(*) num
  from sys.seq$
 where ltrim(audit$,'-') is not null
union all
select 'Procedures' descrip, count(*) num
  from sys.procedure$
 where ltrim(audit$,'-') is not null
union all
select 'Types' descrip, count(*) num
  from sys.type_misc$
 where ltrim(audit$,'-') is not null
union all
select 'Libraries' descrip, count(*) num
  from sys.library$
 where ltrim(audit$,'-') is not null
union all
select 'Directories' descrip, count(*) num
  from sys.dir$
 where ltrim(audit$,'-') is not null
union all
select 'System' descrip, count(*) num
  from sys.audit$ ;


column	username	format           a12	heading "Name"
column	start_time	format           a13	heading "Logon"
column	end_time	format            a6	heading "Logoff"
column	logoff_lread	format   999,999,990	heading "Logicals"
column	logoff_pread	format   999,999,990	heading "Physicals"
column	logoff_lwrite	format   999,999,990	heading "Writes"
break on report 

compute sum of logoff_lread on report
compute sum of logoff_pread on report
compute sum of logoff_lwrite on report

select
  username, to_char(timestamp,'dd-Mon: hh24:mi') start_time, to_char(logoff_time,'hh24:mi') end_time,
  logoff_lread, logoff_pread, logoff_lwrite
  from dba_audit_session
 where logoff_time is not null
order by logoff_lread, logoff_pread ;

# 


spool off
spool off

prompt 
prompt host write c:\temp\show_audit1.spo
prompt 
