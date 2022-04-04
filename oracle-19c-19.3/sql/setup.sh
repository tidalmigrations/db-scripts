#! /bin/bash

su -p oracle -c "$ORACLE_HOME/bin/sqlplus SYS/Dev12345@//localhost:1521/ORCLPDB1 @/opt/oracle/scripts/create_database.sql"
