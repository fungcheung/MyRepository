-- fiilename: show_user.sql

clear col
set lines 333

-- alter session set nls_date_format = 'dd-mm-rrrr hh24:mi:ss' ;
alter session set nls_date_format = 'dd-mm-yyyy' ;

col USERNAME        format a21
col PASSWORD        format a20
col PROFILE         format a20
col ACCOUNT_STATUS  format a18 heading 'Status'


select 'alter user '||username||' identified by values '||''''||password||''''||' ; ' 
from dba_users
where username not in ('SYS','SYSTEM','DBSNMP','ORACLE','OUTLN', 'CHEUSA')
order by 1 ;


select 'alter user '||name||' identified by values '||''''||password||''''||' ; ' 
from sys.user$
where name not in ('SYS','SYSTEM','DBSNMP','ORACLE','OUTLN', 'CHEUSA') and
password is not null
order by 1 ;



select USERNAME, password, ACCOUNT_STATUS, profile, EXPIRY_DATE, LOCK_DATE, CREATED
from dba_users
order by 1 ;


prompt 

clear col
