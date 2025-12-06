-- filename: db.sql

set feed off head off

col PLATFORM_NAME format a50
col value format a30

set pages 1000
set lines 200

select 'Connect: '||user||' \ '||instance_name||' \ '||host_name||' \ '||version from v$instance
union all
select 'Uptime : '||floor(xx)||'days '||floor((xx-floor(xx))*24)||'hours '||round(((xx-floor(xx 
)*24)-floor((xx-floor(xx)*24)))*60)||'minutes'||chr(10)||' ' "Database Uptime" 
from (select host_name,instance_name ,(sysdate-STARTUP_TIME) xx from v$instance)  ;


set feed off head on
column status format a10
column logins format a10
column name format a20

select 
 DBID,
 NAME,
 CREATED,
 status,
 logins,
 LOG_MODE,
 archiver
from v$database, v$instance;


select 
 DBID,
 NAME,
 CREATED,
 status,
 logins,
 LOG_MODE,
 archiver,
 edition
from v$database, v$instance;

show parameter compatible
show parameter db_block_size

select 
 CONTROLFILE_CREATED,
 CONTROLFILE_TIME,
 OPEN_RESETLOGS,
 RESETLOGS_CHANGE#,
 RESETLOGS_TIME
from v$database;


select
 VERSION_TIME,
 OPEN_MODE,
 REMOTE_ARCHIVE
from v$database;

column force_logging format a20
select
 DATABASE_ROLE,
 ARCHIVELOG_COMPRESSION,
 FORCE_LOGGING,
 flashback_on
from v$database;



select
 PLATFORM_ID,
 PLATFORM_NAME,
 CURRENT_SCN
from v$database;



prompt

set lines 200 pages 200
column parameter format a30
column name format a30

Prompt Database NLS parameters ....
select * from NLS_DATABASE_PARAMETERS
where parameter in (
'NLS_LANGUAGE',
'NLS_TERRITORY',
'NLS_CHARACTERSET',
'NLS_NCHAR_CHARACTERSET',
'NLS_DATE_FORMAT',
'NLS_SORT'
)
union
select name, value from v$parameter where name = 'db_block_size';

prompt
Prompt Current NLS parameters ....
column parameter format a50
column value format a50

select * from v$nls_parameters;



