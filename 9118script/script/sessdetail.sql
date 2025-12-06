Set heading on
set pagesize 1000
set linesize 3000

prompt ======= Excluded users: SYSTEM, DBSNMP, SYSMAN =========

column Log_Time format A20
column SID         format 9999
column USERNAME    format a20
column OWNERID     format 999999999
column STATUS      format a10   
column OSUSER      format a30
column PROCESS     format a20
column TERMINAL    format a20
column PROGRAM     format a30
column logon_time format a20
column uga_memory  format a12
column pga_memory  format a12
column sql_text    format a1000 

prompt ============================================================================================================
prompt Session details (order by pga and elapsed_time(microsecond). ORACLE.EXE sessions ignored.
prompt ============================================================================================================

SELECT
--   to_char(sysdate , 'YYYY/DD/MM HH24:MI:SS') as Cur_Time,
   e.SID,
   e.username,
   e.status,
   e.OSUSER,
   e.PROCESS,                                                       
   e.TERMINAL,
   e.PROGRAM,
   to_char(e.LOGON_TIME, 'yyyy-MM-dd hh24:mi:ss') as logon_time,
--   a.UGA_MEMORY,
   b.PGA_MEMORY,
   s.cpu_time,
   s.elapsed_time,
   s.executions,
   s.rows_processed,
   s.sql_text
FROM
 (select y.SID, TO_CHAR(ROUND(y.value/1024),99999999) || ' KB' UGA_MEMORY from v$sesstat y, v$statname z where y.STATISTIC# = z.STATISTIC# and NAME = 'session uga memory') a,
 (select y.SID, TO_CHAR(ROUND(y.value/1024),99999999) || ' KB' PGA_MEMORY from v$sesstat y, v$statname z where y.STATISTIC# = z.STATISTIC# and NAME = 'session pga memory') b,
v$session e, v$sqlarea s
WHERE 
 e.sid=a.sid and
 e.sid=b.sid and 
 s.address(+)=e.sql_address 
 and e.program not like '%ORACLE.EXE%'
 and username not in ('SYSTEM','DBSNMP','SYSMAN')
 ORDER BY b.PGA_MEMORY desc, s.elapsed_time desc;


prompt ============================================================================================================
prompt Blocker sessions
prompt ============================================================================================================

select holding_session, 'blocker_session' description from dba_blockers;
prompt

prompt ============================================================================================================
prompt Waiter sessions
prompt ============================================================================================================

select * from dba_waiters;


