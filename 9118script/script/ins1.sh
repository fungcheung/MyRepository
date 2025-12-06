export CNT=1000000
echo Insert $CNT record to Oracle to generate some workload...
sqlplus / as sysdba <<-EOF
set timing on
DECLARE
BEGIN
	FOR i IN 1..$CNT LOOP
		INSERT INTO A VALUES (i);
		COMMIT;
	END LOOP;
END;
/
EOF


