CREATE USER c##tidal_comm_user IDENTIFIED BY "Dev12345" account unlock;
GRANT CREATE SESSION to c##tidal_comm_user;
GRANT select_catalog_role to c##tidal_comm_user;
