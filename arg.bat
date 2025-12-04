@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
  IF [%1]==[-f] (set sqlfile=%2 & ECHO %2)
  IF [%1]==[-svrlst] (set svrlst=%2 & ECHO %2)

SHIFT
GOTO Loop
:Continue


