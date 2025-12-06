set linesize 188 pages 999

column sid      format 999    heading SessId 
column username format a13    heading OracleUser truncated
column event    format a33    heading Event
column PTEXT    format a33    heading Text
column initial_allocation format a10 heading init_val
column limit_value format a10 heading limit_val



select 
  ss.sid, ss.USERNAME, sw.STATE, sw.event, 
  rtrim( sw.P1TEXT)||':'||rtrim( sw.P2TEXT)||':'||rtrim( sw.P3TEXT) PTEXT
from v$session_wait sw, v$session ss 
where ss.sid = sw.sid ;

column spid     format 999999 heading UnixPid
column sid      format 999    heading SessId 
column serial#  format 999999 heading Ser# 
column username format a13    heading OracleUser truncated
column osuser   format a13    heading OS_User
column terminal format a15    heading Terminal
-- column program  format a88    heading Program
column program  format a44    heading Program
column status   format a1  truncated
column logon    format a17
column idle     format a9

select 
   pro.spid, ses.osuser, ses.username, ses.sid, ses.serial#, 
   status, to_char(logon_time,'dd-mm-yy hh:mi:ss') "Logon",
   floor(last_call_et/3600)||':'||floor(mod(last_call_et,3600)/60)||':'||mod(mod(last_call_et,3600),60) "IDLE", 
   ses.terminal, substr(bgp.name,1,5)||' / '||ses.program, substr(bgp.DESCRIPTION,1,20)
from v$session ses, v$process pro, v$bgprocess bgp
where ses.paddr = pro.addr
  and bgp.paddr = pro.addr
order by ses.username, ses.osuser ;

select 'alter system kill session '||''''||ses.sid||','||ses.serial#||''''|| ' immediate ; '||
'      /*  '||ses.username ||'  */'
from v$session ses 
-- where ( ses.osuser <> 'oracle' or ses.osuser is null) 
where ses.username is not null ;

column initial_allocation format a10 heading INIT_VAL
column limit_value format a10 heading LIMIT_VAL

select resource_name, current_utilization curr_util, max_utilization max_util, initial_allocation, limit_value from v$resource_limit
where resource_name in ('processes','sessions');



