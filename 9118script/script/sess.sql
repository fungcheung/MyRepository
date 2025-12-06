column username format a15
column osuser format a20
column machine format a30
column TERMINAL    format a15
column program format a20

prompt ======= Excluded users: SYSTEM, DBSNMP, SYSMAN =========
select sid, username, osuser, machine, terminal, program from v$session 
where username not in ('SYSTEM','DBSNMP','SYSMAN') order by username, sid;




Set heading on
set pagesize 1000
set linesize 1000

column Log_Time format A20
column SID         format 9999
column USERNAME    format a20
column OWNERID     format 999999999
column STATUS      format a10   
column OSUSER      format a30
column PROCESS     format a15
column MACHINE     format a30
column TERMINAL    format a15
column PROGRAM     format a20
column logon_time_str format a20
column uga_memory  format a12
column pga_memory  format a12

SELECT
--   to_char(sysdate , 'YYYY/DD/MM HH24:MI:SS') as Log_Time,
   e.SID,
   e.username,
   e.status,
--   e.OSUSER,
   e.PROCESS,                                                       
   e.TERMINAL,
--   e.PROGRAM,
   to_char(e.LOGON_TIME, 'yyyy-MM-dd hh24:mi:ss') as logon_time_str,
   a.UGA_MEMORY,
   b.PGA_MEMORY
FROM
 (select y.SID, TO_CHAR(ROUND(y.value/1024),99999999) || ' KB' UGA_MEMORY from v$sesstat y, v$statname z where y.STATISTIC# = z.STATISTIC# and NAME = 'session uga memory') a,
 (select y.SID, TO_CHAR(ROUND(y.value/1024),99999999) || ' KB' PGA_MEMORY from v$sesstat y, v$statname z where y.STATISTIC# = z.STATISTIC# and NAME = 'session pga memory') b,
v$session e
WHERE  e.sid=a.sid 
   and e.sid=b.sid
   and username not in ('SYSTEM','DBSNMP','SYSMAN')
ORDER BY
   e.username,
   e.sid,
   e.LOGON_TIME,
   a.UGA_MEMORY desc;



