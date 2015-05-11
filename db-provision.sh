rm -rf ora-01.sql 2> /dev/null
rm -rf ora.log 2> /dev/null
echo "-- " > ora-01.sql
echo "-- concedendo privilégios globais " >> ora-01.sql
echo "grant all on SYS.DBMS_CRYPTO to public; " >> ora-01.sql
echo "grant all on SYS.UTL_TCP to public; " >> ora-01.sql
echo "-- " >> ora-01.sql
echo "-- criando TableSpace para o SOMA " >> ora-01.sql
echo "CREATE TABLESPACE TS_SOMA " >> ora-01.sql
echo "  LOGGING " >> ora-01.sql
echo "  DATAFILE '$SOMA_TBSPACE_DIR/soma.dbf' " >> ora-01.sql
echo "  SIZE 1000M " >> ora-01.sql
echo "  REUSE " >> ora-01.sql
echo "  AUTOEXTEND ON" >> ora-01.sql
echo "  NEXT 100M " >> ora-01.sql
echo "  MAXSIZE 10000M " >> ora-01.sql
echo "  EXTENT MANAGEMENT LOCAL" >> ora-01.sql
echo "; " >> ora-01.sql
echo "-- " >> ora-01.sql
echo "-- criando o usuario " >> ora-01.sql
echo "CREATE USER soma " >> ora-01.sql
echo "  identified by soma_123456 " >> ora-01.sql
echo "  default tablespace TS_SOMA " >> ora-01.sql
echo "  temporary tablespace TEMP " >> ora-01.sql
echo "  quota unlimited on TS_SOMA " >> ora-01.sql
echo "; " >> ora-01.sql
echo "-- " >> ora-01.sql
echo "-- concedendo privilégios ao usuario " >> ora-01.sql
echo "grant connect, create session, resource, dba to soma; " >> ora-01.sql
