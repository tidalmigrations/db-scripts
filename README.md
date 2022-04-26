# db-scripts

A compilation of Containerized Databases with minimum data and permissions configured to work with Tidal Tools Database analysis.

For more information about the permissions Tidal Tools needs to be able to perform database analysis, Check this [guide](https://guides.tidalmg.com/analyze-database.html)

### Requirements

- Docker
- Docker Compose

### Contents

```text
db-scripts
├── docker-compose.yml
├── mysql-8
|   └── sql
|       ├── create_tables.sql
|       ├── fill_tables.sql
|       └── tidal_setup.sql
├── postgres-10-5
|   └── sql
|       ├── create_tables.sql
|       ├── fill_tables.sql
|       └── tidal_setup.sql
├── mssql-2019
|   └── sql
|       ├── create_tables.sql
|       ├── fill_tables.sql
|       └── tidal_setup.sql
├── oracle-19c-19.3
|   ├── docker-compose.yml
|   ├── 19.3.0
|   └── sql
|       ├── create_database.sql
├── ...more to come

```

### How to use

Simply run `docker-compose up -d` and the databases will be up and running and ready to be analyzed.

### Connecting

#### MSSQL-2019

Connect as root user
`sqlcmd -S "<public-ipv4-dns>,1433" -U SA -P "Dev12345"`

Connect as Tidal user
`sqlcmd -S "<public-ipv4-dns>,1433" -U Tidal -P "Dev1234"`

#### Oracle 19c-19.3

Additional steps are required to spin up the oracle database. These instructions assume you're using the `oracle-databases` terraform script from the `infrastructure-deployments` repo to create the instance.

After deploying the above instance, it will take around 45 minutes for the user data script to complete and the container to be initialized. Run `docker ps` to check the health of the container. Wait until it reads `healthy` before attempting to connect. It will read `unhealthy` before `healthy` because of how long it takes oracle to start.

`sudo docker exec -it --user=oracle <container-name> bash`

Connect to the CDB.

`sqlplus SYS/Dev12345@ORCLCDB AS SYSDBA`

Run this script in the SQL terminal. It creates the CDB user Tidal Tools will use.

`@/opt/oracle/scripts/create_cdb_user.sql`

Exit sqlplus (`exit`) and connect to the default PDB.

`sqlplus SYS/Dev12345@ORCLPDB1 AS SYSDBA`

Run this script in the SQL terminal. It creates tables, adds data and creates the PDB tidal user.

`@/opt/oracle/scripts/create_database.sql`

Check that the tidal user exists by logging out (`exit`) and back in as this user.

`sqlplus tidal/Dev12345@ORCLPDB1`

You should now have a running oracle database to test against.

### Troubleshooting
If you are running the scrips inside an ec2 instance, make sure you configure its security group and inbound rules to allow for port connectivity.

SQL Server requires a machine with at least 2GB RAM.
