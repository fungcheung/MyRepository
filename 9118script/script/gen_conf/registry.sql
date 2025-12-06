spool registry.log

set linesize 188 pages 999

col COMP_ID format a10
col COMP_NAME format a30
col VERSION format a10
col STATUS format a10
col MODIFIED format a15
col NAMESPACE format a15
col CONTROL format a15
col SCHEMA format a15
col PROCEDURE format a15
col STARTUP format a15
col optime format a40
col message format a50
col comments format a50
col action_time format a35
col action format a15

prompt =========================================================================================================================================================
prompt Show components loaded into the database
 
select COMP_ID, COMP_NAME, VERSION, STATUS, MODIFIED, NAMESPACE, control, schema, procedure from dba_registry;


REM prompt REM =========================================================================================================================================================
REM prompt Show operating information about components loaded into the database
REM select optime, comp_id, operation, message from dba_registry_log;


prompt =========================================================================================================================================================
prompt Show information about upgrade, downgrade and critical patch updates applied to the database

select action_time, action, version, ID, comments from dba_registry_history;

spool off