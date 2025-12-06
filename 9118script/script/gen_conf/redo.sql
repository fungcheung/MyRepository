spool redo.log

set pages 200
set lines 200

prompt ==================================================================================================
prompt # Redo log information
prompt ==================================================================================================



col STATUS format a10
col MEMBER format a40

select * from sys.v_$log;

select * from sys.v_$logfile;


spool off