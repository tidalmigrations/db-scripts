CREATE USER 'tidal'@'%' IDENTIFIED BY 'Dev1234';
GRANT PROCESS,REFERENCES, SHOW DATABASES, SHOW VIEW ON *.* TO 'tidal'@'%';
GRANT SELECT ON sys.* TO 'tidal'@'%';
GRANT SELECT ON performance_schema.* TO 'tidal'@'%';
GRANT SELECT ON mysql.slave_master_info TO tidal;
GRANT SELECT ON mysql.slave_relay_log_info TO tidal;
GRANT SELECT ON mysql.user TO tidal;


GRANT SHOW_ROUTINE ON *.* TO 'tidal'@'%';
GRANT SELECT ON mysql.user TO 'tidal'@'%';
