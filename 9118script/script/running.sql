-- Filename: running.sql

alter session set optimizer_features_enable='9.2.0';

set linesize 200
set pagesize 9999

prompt === Username ('DBSNMP','SYSMAN') excluded === 

break on sid skip 1

prompt #################################################################################################################
prompt << Jobs Running, DBA_JOBS >>
prompt #################################################################################################################

col sess format 99    heading 'Ses' 
col jid  format 99999 heading 'Id' 
col subu format a10   heading 'Submitter'     trunc 
col secd format a10   heading 'Security'      trunc 
col proc format a20   heading 'Job'           word_wrapped 
col lsd  format a5    heading 'Last|Ok|Date'  
col lst  format a5    heading 'Last|Ok|Time' 
col nrd  format a5    heading 'This|Run|Date' 
col nrt  format a5    heading 'This|Run|Time' 
col fail format 99    heading 'Err' 
 
select 
  djr.sid                        sess, 
  djr.job                        jid, 
  dj.log_user                    subu, 
  dj.priv_user                   secd, 
  dj.what                        proc, 
  to_char(djr.last_date,'MM/DD') lsd, 
  substr(djr.last_sec,1,5)       lst, 
  to_char(djr.this_date,'MM/DD') nrd, 
  substr(djr.this_sec,1,5)       nrt, 
  djr.failures                   fail 
from 
  sys.dba_jobs dj, 
  sys.dba_jobs_running djr 
where 
  djr.job = dj.job  ;



prompt #################################################################################################################
prompt << SQLs Running >> order by user
prompt #################################################################################################################

column osuser format a20
column username format a20
column spid format a10
column sid format 9999
column FIRST_LOAD_TIME format a30
column sid format 9999
column module format a15
column sql_text format a60 wrap


select /* running.sql */  osuser, s.username, p.spid, sid,FIRST_LOAD_TIME, SHARABLE_MEM, PERSISTENT_MEM, 
      RUNTIME_MEM, EXECUTIONS, LOADS, PARSE_CALLS , DISK_READS Disk, ROWS_PROCESSED , 
      s.lockwait,s.status ,q.module,sql_text
 FROM v$session s, v$sqlarea q, v$process p
WHERE s.sql_hash_value = q.hash_value
  AND p.addr = s.paddr
  AND s.sql_address = q.address
  and s.username not in ('DBSNMP','SYSMAN')
  and ( s.status <> 'INACTIVE' or s.program='OraPgm')
order by osuser, p.username ;


prompt #################################################################################################################
prompt << Inactive SQLs >> order by user
prompt #################################################################################################################

select /* running.sql */  osuser, s.username, p.spid, sid,FIRST_LOAD_TIME, SHARABLE_MEM, PERSISTENT_MEM, 
      RUNTIME_MEM, EXECUTIONS, LOADS, PARSE_CALLS , DISK_READS Disk, ROWS_PROCESSED , 
      s.lockwait,s.status ,q.module,sql_text
 FROM v$session s, v$sqlarea q, v$process p
WHERE s.sql_hash_value = q.hash_value
  AND p.addr = s.paddr
  AND s.sql_address = q.address
  and s.username not in ('DBSNMP','SYSMAN')
  and ( s.status = 'INACTIVE') 
order by osuser, p.username ;


column spid     format a10 heading UnixPid
REM column sid      format a20    heading SessId
REM column serial#  format a20 heading Ser#
column username format a13    heading OracleUser truncated
column osuser   format a20    heading OS_User
column terminal format a15    heading Terminal
column program  format a44    heading Program
column logon    format a30
column idle     format a9
column last_sql format a80 wrap

prompt #################################################################################################################
prompt << Inactive session details with last SQL>> order by user
prompt #################################################################################################################

select 
   ses.osuser, ses.username, pro.spid, ses.sid, ses.serial#,
   status, to_char(logon_time,'dd-mm-yy hh:mi:ss') "Logon",
   floor(last_call_et/3600)||':'||floor(mod(last_call_et,3600)/60)||':'||mod(mod(last_call_et,3600),60) "IDLE", ses.terminal, ses.program, sql.sql_text last_sql
from v$session ses, v$process pro, v$sqlarea sql
where ses.status = 'INACTIVE' and
ses.paddr = pro.addr and ses.prev_sql_addr = sql.address and ses.prev_HASH_VALUE = sql.HASH_VALUE
and ses.username not in ('DBSNMP','SYSMAN')
order by  ses.username, ses.osuser, ses.sid, pro.spid ;


clear break 
ttitle off

