set pages 9000
set lines 400

spool fuhwm.log

prompt
prompt =================================================================================================================
prompt feature usage statistics
prompt =================================================================================================================
select name, VERSION, DETECTED_USAGES, currently_used, LAST_USAGE_DATE, LAST_SAMPLE_PERIOD, SAMPLE_INTERVAL, LAST_SAMPLE_DATE, description from DBA_FEATURE_USAGE_STATISTICS
order by version desc, name;


prompt
prompt =================================================================================================================
prompt high water mark statistics
prompt =================================================================================================================

select name, VERSION, HIGHWATER,LAST_VALUE, description from DBA_HIGH_WATER_MARK_STATISTICS
order by version desc, name;

spool off
