CREATE USER tidal WITH PASSWORD 'Dev12345';

DO $$ DECLARE comm_rec RECORD;
BEGIN
    FOR comm_rec IN
		SELECT 'GRANT REFERENCES ON ALL TABLES IN SCHEMA '||schema_name||' TO tidal' AS comm FROM information_schema.schemata
	LOOP
        EXECUTE comm_rec.comm;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

GRANT REFERENCES ON ALL TABLES IN SCHEMA public to tidal;

GRANT SELECT ON pg_catalog.pg_config TO tidal;
GRANT EXECUTE ON function pg_catalog.pg_config TO tidal;
GRANT SELECT ON pg_catalog.pg_proc TO tidal;
GRANT SELECT ON pg_catalog.pg_namespace TO tidal;

GRANT SELECT ON pg_catalog.pg_hba_file_rules TO tidal;
GRANT SELECT ON pg_catalog.pg_roles TO tidal;
GRANT pg_read_all_settings TO tidal;
GRANT pg_read_all_stats TO tidal;