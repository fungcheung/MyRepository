spool rman_backup.log

prompt ##############################################################################
prompt # Show RMAN backup history
prompt ##############################################################################

alter session set nls_date_format = 'dd-mm-yyyy hh24:mi' ; 

set pages 9999
set lines 200
set long 99990
select input_type, start_time, end_time, status from v$rman_backup_job_details order by start_time
/

spool off





