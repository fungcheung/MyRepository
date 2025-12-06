set feed off
set head off
set linesize 100
set pagesize 200
select name, open_mode from v$pdbs where name='GISP' and open_mode='READ WRITE';
exit

