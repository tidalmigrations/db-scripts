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

After deploying the above instance, **it will take around 45 minutes for the user data script to complete** and the container to be initialized. Run `docker ps` to check the health of the container. Wait until it reads `healthy` before attempting to connect. It may read `unhealthy` before `healthy` because of how long it takes oracle to start.

After confirming that the container is healthy, we can connect to it and get to work.

`sudo docker exec -it --user=oracle <container-name> bash`

The type of Oracle database we're using is called a multitenant container database. This means that there's a CDB (container database) as the outside layer, and inside this CDB are multiple PDBs (pluggable databases). In our example, we have one PDB which sits inside our CDB.

To allow Tidal Tools to work with this, we need to connect to the CDB and create a tidal user. We then need to ALSO connect to the PDB and create another tidal user. While we're in the PDB that's where we'll add the demo data. The only data that the CDB holds is the PDBs. 


    ┌───CDB──────────────────────────────────────────────┐
    │                                                    │
    │   Tidal CDB user                                   │
    │                                                    │
    │       ┌────PDB──────────────────────────────┐      │
    │       │                                     │      │
    │       │    Tidal PDB user                   │      │
    │       │                                     │      │
    │       │    Demo data                        │      │
    │       │                                     │      │
    │       │                                     │      │
    │       └─────────────────────────────────────┘      │
    │                                                    │
    │                                                    │
    └────────────────────────────────────────────────────┘


First, we connect to the CDB.

`sqlplus SYS/Dev12345@ORCLCDB AS SYSDBA`

Run this script in the SQL terminal. It creates the CDB user that Tidal Tools will use.

`@/opt/oracle/scripts/create_cdb_user.sql`

Exit sqlplus (`exit`) and connect to the default PDB.

`sqlplus SYS/Dev12345@ORCLPDB1 AS SYSDBA`

Run this script in the SQL terminal. It creates tables, adds data and creates the PDB tidal user.

`@/opt/oracle/scripts/create_database.sql`

Check that the tidal user exists by logging out (`exit`) and back in as this user.

`sqlplus tidal/Dev12345@ORCLPDB1`

You should now have a running oracle multitenant database to test against.

### Troubleshooting
If you are running the scrips inside an ec2 instance, make sure you configure its security group and inbound rules to allow for port connectivity.

SQL Server requires a machine with at least 2GB RAM.
