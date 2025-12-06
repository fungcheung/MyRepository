set linesize 188 pages 999

col segment_name format a30
col owner format a15
col segment_type format a15
col tablespace_name format a15


prompt =========================================================================================================================================================
prompt Enter tablespace name to show first 200 objects order by SIZE
 
create table james$temp as 
select owner, segment_name, segment_type, BYTES/1024/1024 Size_M ,tablespace_name from dba_segments where tablespace_name = upper('&tablespace') and segment_name not like 'BIN$%'
order by Size_M desc, owner,segment_type;

select * from james$temp where rownum <= 200;
drop table james$temp purge;

prompt =========================================================================================================================================================
prompt Enter schema name to show first 80 objects order by SIZE
 

create table james$temp as 
select owner, segment_name, segment_type, BYTES/1024/1024 Size_M ,tablespace_name from dba_segments where owner = upper('&schema') and segment_name not like 'BIN$%' order by Size_M desc, owner,segment_type ;
select * from james$temp where rownum <= 80;
drop table james$temp purge;


prompt =========================================================================================================================================================
prompt Enter segment name

create table james$temp as
select owner, segment_name, segment_type, BYTES/1024/1024 Size_M, INITIAL_EXTENT, next_extent, extents ,tablespace_name from dba_segments 
where segment_name like upper('%&segment_name%') order by Size_M desc;
select * from james$temp where rownum <= 50;
drop table james$temp purge;



prompt =========================================================================================================================================================
prompt Show largest segments
prompt Enter the minimum size(M) to show

create table james$temp as
select owner, segment_name, segment_type, BYTES/1024/1024 Size_M ,tablespace_name from dba_segments 
where bytes/1024/1024 > &size and owner not in ('SYS','SYSTEM') and segment_name not like 'BIN$%'
 order by Size_M desc ;

select * from james$temp where rownum <= 80;
drop table james$temp purge;

