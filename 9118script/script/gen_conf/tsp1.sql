spool tsp1.log

set heading on                                                           
set feedback on                                                          
set timing on

alter session set optimizer_features_enable='9.2.0';

column tablespace_name   format a20          heading "Tablespace Name" 
column file_name         format a45          heading "File|Name" 
column Size_M            format 9,999,999.99 heading "Allocated|MBytes"
column Free_M            format 9,999,999.99 heading "Free|MBytes"
column Used_M            format 9,999,999.99 heading "Used|MBytes"
column Used_P            format 999.99       heading "Used %%"
column frag_count        format 999,999      heading "No. of|Free Exts" 
column large_frag        format 99,999,999   heading "Largest|Exts (KB)"  
column small_frag        format 99,999,999   heading "Smallest|Exts (KB)" 
column initext           format 999,999      heading "Initial|Exts (KB)" 
column nxtreqext         format 999,999      heading "Nxt Reqd|Exts (KB)" 
column autoextensible    format a4           heading "Auto"

alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss' ;

select 'Datetime: ' || sysdate from dual;

compute sum of size_M free_M used_m on report
break on report
                                                                         
select a.tablespace_name, a.autoextensible, a.a1 "Size_M", a.a1-nvl(b.b1,0) "Used_M",
nvl(b.b1,0) "Free_M" , (a.a1-nvl(b.b1,0))/a.a1*100 "Used_P",
b2 frag_count, b3 large_frag, b4 small_frag,
nvl(c1,0) nxtreqext
from
(SELECT tablespace_name, autoextensible, sum(bytes/1024/1024) a1
   FROM dba_data_files
group BY tablespace_name, autoextensible
union
SELECT tablespace_name, autoextensible, sum(bytes/1024/1024) a1
   FROM dba_temp_files
group BY tablespace_name, autoextensible) a,
(SELECT tablespace_name,
        SUM(bytes/1024/1024) b1,
        count(*)             b2,
        max(bytes/1024)      b3,
        min(bytes/1024)      b4
   FROM dba_free_space
   GROUP BY tablespace_name) b,
(SELECT tablespace_name,
        MAX(NEXT_EXTENT)/1024  c1
   FROM DBA_SEGMENTS
  GROUP BY tablespace_name) c
where a.tablespace_name = b.tablespace_name (+)
and  a.tablespace_name = c.tablespace_name (+)
-- order by (a.a1-b.b1)/a.a1*100 desc
order by 1  ;

prompt #######################################################################################################################

spool off


