@echo off
echo connect system/Password123@gdat9174 > %0.tmp
echo show user >> %0.tmp
echo alter session set nls_date_format = 'dd-mm-rrrr hh24:mi:ss' ; >> %0.tmp

sqlplus /nolog @%0.tmp

del %0.tmp
