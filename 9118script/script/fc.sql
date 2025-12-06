--
-- Find all tables, views, and clusters containing a certain column name
--

col owner format a30
col table_name format a40
col column_name format a40

select owner,table_name, column_name from dba_tab_columns where column_name like upper('%&name%')
order by owner desc, table_name, column_name;



