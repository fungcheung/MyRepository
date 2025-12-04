-- fiilename: show_pdbs.sql

clear col
set lines 333 pages 300

-- alter session set nls_date_format = 'dd-mm-rrrr hh24:mi:ss' ;
alter session set nls_date_format = 'dd-mm-yyyy' ;

col MB        format 999,999,999
col name        format a20
col open_time         format a50
col instance_name         format a20
col con_name         format a20

select con_id,guid,dbid,name,open_mode,RECOVERY_STATUS,open_time,total_size/1024/1024 MB from v$pdbs where name <> 'PDB$SEED' order by MB desc;

prompt =========================================================================================================================================================
prompt Show PDB saved state

select instance_name,con_name,state from cdb_pdb_saved_states order by con_name,instance_name;

clear col
