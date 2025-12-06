set linesize 188 pages 999

col COMP_ID format a10
col COMP_NAME format a40
col VERSION format a10
col STATUS format a10
col MODIFIED format a12
col NAMESPACE format a15
col CONTROL format a15
col SCHEMA format a15
col PROCEDURE format a45
col STARTUP format a15
col optime format a40
col message format a50
col comments format a50
col action_time format a35
col action format a15
col bundle_series format a15
col ACTION_TIME format a35
col DESCRIPTION format a550
col BUNDLE_SERIES format a15

alter session set nls_language='AMERICAN' nls_territory='AMERICA';
REM alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss' ;
alter session set nls_date_format = 'dd-mm-yyyy' ;

prompt =========================================================================================================================================================
prompt Show components loaded into the database
 
REM select COMP_ID, COMP_NAME, VERSION, STATUS, MODIFIED, NAMESPACE, control, schema, procedure from dba_registry;
REM select COMP_ID, COMP_NAME, VERSION, STATUS, MODIFIED, schema, procedure from dba_registry;
select COMP_ID, COMP_NAME, VERSION, STATUS, substr(modified,1,12) modified, schema from dba_registry;


REM prompt REM =========================================================================================================================================================
REM prompt Show operating information about components loaded into the database
REM select optime, comp_id, operation, message from dba_registry_log;


prompt =========================================================================================================================================================
prompt Show information about upgrade, downgrade and critical patch updates applied to the database
select action_time, action, version, ID, comments from dba_registry_history;
-- select action_time, action, version, ID, bundle_series, comments from dba_registry_history;

prompt =========================================================================================================================================================
prompt Show information about upgrade, downgrade and critical patch updates applied to the database 12c

select PATCH_ID, VERSION, BUNDLE_ID, ACTION, STATUS, ACTION_TIME, BUNDLE_SERIES  from dba_registry_sqlpatch;


