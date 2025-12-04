
set lines 222

column profile format a30
column RESOURCE_NAME format a30
column RESOURCE_TYPE format a8
column limit format a30


select * from dba_profiles
order by 1,2 ;

prompt
prompt


