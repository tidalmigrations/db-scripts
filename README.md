# db-scripts

A compilation of Containerized Databases with minimum data and permissions configured to work with Tidal Tools Database analysis.

For more information about the permissions Tidal Tools needs to be able to perform database analysis, Check this [guide](https://guides.tidalmg.com/analyze-database.html)


### Requirements

- Docker
- Docker Compose


### Contents

```
db-scripts
├── mysql-8
|   ├── docker-compose.yml
|   └── sql
|       ├── create_tables.sql
|       ├── fill_tables.sql
|       └── tidal_setup.sql
├── postgres-10-5
|   ├── docker-compose.yml
|   └── sql
|       ├── create_tables.sql
|       ├── fill_tables.sql
|       └── tidal_setup.sql
├── ...more to come

```


### How to use

1. Navigate inside the database you would like to start

2. Run `docker-compose up -d` 

3. That is it. The Database will be up and running and ready to be analyzed.


### Oracle

The oracle image pulled from docker hub has a tidal user and demo data pre-installed. This is that user that `machine-stats` can use to analyze the DB.

User: tidal
Password: Dev1234
Database (PDB) name: XEPDB1

You can manually connect to the DB from inside the container with the following command, to verify this. 
`sqlplus tidal/Dev1234@XEPDB1`

Note that you need to install `sqlplus` on the instance (long process) if you want to connect from outside the container.

### Troubleshooting
If you are running the scrips inside an ec2 instance, make sure you configure its security group and inbound rules to allow for port connectivity.
