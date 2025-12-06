
#
# Create below table if not exist
#
# create table test_data 
# ( 
#   id number, 
#   first_name varchar2(16), 
#   last_name varchar2(24), 
#   amount number(6,2), 
#   purchase_date date 
# );

. ~/.bash_profile

export CNT=100000
echo Insert $CNT record to test_data to generate some workload... PID = $$
sqlplus -S /nolog <<-EOF
connect scapp/scapp123@DG1GISP
set timing on
insert into test_data 
select 
  rownum, 
  initcap(dbms_random.string('l',dbms_random.value(2,16))), 
  initcap(dbms_random.string('l',dbms_random.value(2,24))), 
  round(dbms_random.value(1,1000),2), 
  to_date('01-JAN-2008', 'DD-MON-YYYY') + dbms_random.value(-100,100) 
from 
  (select level from dual connect by level <= $CNT);
commit;
EOF


