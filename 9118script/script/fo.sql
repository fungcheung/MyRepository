set pages 2000 lines 200
col object_name format a50
col owner format a30
col object_type format a30

select owner,object_name, object_type from dba_objects where object_name like upper('%&name%')
order by owner desc, object_type, object_name;


