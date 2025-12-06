/* ---------------------------------------------------------------------------
 Filename: create_awr_report_for_database.sql
 CR/TR#  :
 Purpose : Create awr report. Please spool the output to an HTML file yourself.
           Enter your start/end hours in v_begin_hr and v_end_hr, the script will generate report of last (start,end) hour.
          
 Date    : 30.01.2013.
 Author  : Damir Vadas
 Modifier  : James Cheung

 Remarks : Run as privileged user

 --------------------------------------------------------------------------- */

set serveroutput on
set linesize 166
set pagesize 600

variable task_name  varchar2(40);


DECLARE
  cursor c_instance is
    SELECT instance_number, instance_name
    FROM   v$instance
    ORDER BY 1
  ;

  v_begin_hr	VARCHAR2(20) := '01';
  v_end_hr	VARCHAR2(20) := '22';
  
  v_dbid        v$database.dbid%TYPE;
  v_dbname      v$database.name%TYPE;
  v_inst_num    v$instance.instance_number%TYPE := 1;
  v_begin       NUMBER;
  v_end         NUMBER;
  v_options     NUMBER := 8; -- 0=no options, 8=enable addm feature
  v_file        UTL_FILE.file_type;
  v_file_name   VARCHAR(50);

  id number;
  name varchar2(100);
  descr varchar2(500);


BEGIN
  -- get database id
  SELECT dbid, name
    INTO v_dbid, v_dbname
    FROM v$database;

  -- get end snapshot id
  SELECT MAX(snap_id)
    INTO v_end
    FROM dba_hist_snapshot
   WHERE to_char(begin_interval_time,'HH24') = v_end_hr;

  -- get start snapshot id
  SELECT MAX(snap_id)
    INTO v_begin
    FROM dba_hist_snapshot
   WHERE to_char(begin_interval_time,'HH24') = v_begin_hr
     AND snap_id < v_end;
    
  
  -- let's go to real work...write awrs to files... 
  FOR v_instance IN c_instance LOOP


    name := '';
    descr := 'ADDM report';

    dbms_advisor.create_task('ADDM',id,name,descr,null);

    :task_name := name;

    -- set time window
    dbms_advisor.set_task_parameter(name, 'START_SNAPSHOT', v_begin);
    dbms_advisor.set_task_parameter(name, 'END_SNAPSHOT', v_end);

    -- set instance number
    dbms_advisor.set_task_parameter(name, 'INSTANCE', v_instance.instance_number);

    -- set dbid
    dbms_advisor.set_task_parameter(name, 'DB_ID', v_dbid);

    -- execute task
    dbms_advisor.execute_task(name);


    END LOOP;



EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

set long 1000000 pagesize 0 longchunksize 1000
column get_clob format a80

select dbms_advisor.get_task_report(:task_name, 'TEXT', 'TYPICAL')
from   sys.dual;
/

exit;


