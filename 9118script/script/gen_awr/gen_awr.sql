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
  v_start_date  VARCHAR2(20);
  v_end_date    VARCHAR2(20);
  v_options     NUMBER := 8; -- 0=no options, 8=enable addm feature
  v_file        UTL_FILE.file_type;
  v_file_name   VARCHAR(50);


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
    
  SELECT to_char(begin_interval_time,'YYMMDD_HH24MI')
    INTO v_start_date
    FROM dba_hist_snapshot
   WHERE snap_id = v_begin
     AND instance_number = v_inst_num
  ;

  SELECT to_char(begin_interval_time,'HH24MI')
    INTO v_end_date
    FROM dba_hist_snapshot
   WHERE snap_id = v_end
     AND instance_number = v_inst_num
  ;
  
  -- let's go to real work...write awrs to files... 
  FOR v_instance IN c_instance LOOP
    FOR c_report IN (
      SELECT output
        FROM TABLE(dbms_workload_repository.awr_report_html( v_dbid,
                                                             v_instance.instance_number,
                                                             v_begin,
                                                             v_end,
                                                             v_options
                                                            )
                  )
    ) LOOP
      dbms_output.put_line(c_report.output);
    END LOOP;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

exit;


