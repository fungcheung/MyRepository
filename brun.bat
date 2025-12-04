REM
REM This script is to run a sql file against servers defined in svr.txt
REM svr.txt format is "tns_entry login pwd"
REM

echo off

if [%1]==[] (msg * /time:0 Syntax Example: %0 svr.txt brun.sql & exit)
if [%2]==[] (msg * /time:0 Syntax Example: %0 svr.txt brun.sql & exit)

if not exist %1 (msg * /time:0 Syntax Example: %0 svr.txt brun.sql & exit)
if not exist %2 (msg * /time:0 Syntax Example: %0 svr.txt brun.sql & exit)


set parfile=%1
set sqlfile=%2


FOR /F "eol=; tokens=1,2,3 delims= " %%a IN (%parfile%) DO call :RUN %%a %%b %%c

goto END

:RUN
echo ### %1 ###
sqlplus -S -L %2/%3@%1 < %sqlfile%
echo ========================================================================================================================

GOTO NEXT

:NEXT

:END
