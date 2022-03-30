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

### Troubleshooting
If you are running the scrips inside an ec2 instance, make sure you configure its security group and inbound rules to allow for port connectivity.

SQL Server requires a machine with at least 2GB RAM.
