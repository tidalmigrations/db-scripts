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

Additional steps are required to spin up the oracle database. These instructions assume you're using the `databases` terraform script from `infrastructure-deployments` to create the instance. If not, adjust the paths in the provided commands accordingly.

first, download the oracle binaries into the `19.3.0` directory. This should take about 10 minutes. These binaries are stored in an S3 bucket in `riptide` called `oracle-binaries-riptide`.

`sudo wget -P /home/ubuntu/db-scripts/oracle-19c-19.3/19.3.0 "https://oracle-binaries-riptide.s3.ca-central-1.amazonaws.com/LINUX.X64_193000_db_home.zip"`

Next, run docker compose up. You can omit the `-d` from this command to run it in the foreground and watch the process.

`sudo docker-compose -f /home/ubuntu/db-scripts/oracle-19c-19.3/docker-compose.yml up -d`

After the build completes, run `docker ps` to check the health of the container. Wait until it reads `healthy` before attempting to connect. This is likely to take some time, around half an hour. It will read `unhealthy` before `healthy` because of how long it takes oracle to start.

After confirming that the container is healthy, we need to connect to the database and fill it with data.

`sudo docker exec -it --user=oracle <container-name> bash`

Connect to the default PDB.

`sqlplus SYS/Dev12345@ORCLPDB1 AS SYSDBA`

Run this script in the SQL terminal. It creates tables, adds data and creates the tidal user.

`@/opt/oracle/scripts/create_database.sql`

Check that the tidal user exists by logging out (`exit`) and back in as this user.

`sqlplus tidal/Dev12345@ORCLPDB1`

You should now have a running oracle database to test against.

### Troubleshooting
If you are running the scrips inside an ec2 instance, make sure you configure its security group and inbound rules to allow for port connectivity.

SQL Server requires a machine with at least 2GB RAM.
