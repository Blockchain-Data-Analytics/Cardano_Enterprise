[back to index](README.md)

# Software setup

## Cardano node

https://github.com/IntersectMBO/cardano-node

we select version 8.7.3: 
`git checkout 8.7.3`

building the software using _nix_: 
`nix build .#mainnet/node -o mainnet-node-8.7.3`

run with:
`./mainnet-node-8.7.3/bin/cardano-node-mainnet`

The Cardano node maintains a local state which takes quite some space on disk:
```sh
170G	state-node-mainnet
```
This should be considered before starting the node.


## Cardano Db-sync

https://github.com/IntersectMBO/cardano-db-sync

description of the installation process: https://github.com/IntersectMBO/cardano-db-sync/blob/master/doc/installing-with-nix.md

we select version 13.2.0.1: 
`git checkout 13.2.0.1`

building the software using _nix_: 
`nix build . -o  db-sync-13.2.0.1`

the binary is built as: `./db-sync-13.2.0.1/bin/cardano-db-sync`

Prepare a run script:

```sh
#!/bin/sh

set -ex

BASEDIR=$(realpath $(dirname $0))

VERSION="13.2.0.1"

DBSYNC=${BASEDIR}/db-sync-${VERSION}/bin/cardano-db-sync
CONFIG=${BASEDIR}/config/mainnet-config.yaml
NODESOCKET=${HOME}/cardano-node.git/state-node-mainnet/node.socket
STATEDIR=${BASEDIR}/ledger-state/mainnet
SCHEMADIR=${BASEDIR}/schema

${DBSYNC} --config ${CONFIG} \
    --socket-path ${NODESOCKET} \
    --state-dir ${STATEDIR} \
    --schema-dir ${SCHEMADIR}
```
This assumes that the Cardano node is located in ${HOME}/cardano-node.git/ and that a number of environment variables are set:

* PGPASSFILE  ; should point to a pgpass file that contains the credentials to connect to the database
* PGUSER  ; the user to use for connecting to the database
* PGDATABASE  ; the name of the database
* PGHOST  ; usually "localhost"
* PGPORT  ; usually "5432"


## PostgreSQL

Tuning a PostgreSQL cluster is an art!

We usually set higher values than the defaults for the following settings:

* shared_buffers = 2GB
* work_mem = 256MB
* maintenance_work_mem = 256MB
* max_parallel_workers = 12
* max_parallel_workers_per_gather = 4
* effective_cache_size = 12GB

And, if one wants to use dynamic replication, then also add this:

* wal_level = 'logical'

The database performance is directly dependent on the availability of enough RAM and the throughput of the disks. It is advisable to run PostgreSQL on a machine with enough disk space on SSD. Although, one could achive reasonable results with a hybrid approach using spinning disks for tables and placing the indezes on an SSD (tablesapce).

### PostgreSQL proxies

A user normally connects to a database through a proxy which itself connects and forwards to PostgreSQL instances. This provides the ability to switch from one database server to another within short time such that the user usually does not recognise the interruption.

We are investigating the following products:

* [pgCat](https://github.com/postgresml/pgcat)
* [pgBouncer](https://github.com/pgbouncer/pgbouncer)
* [odyssey](https://github.com/yandex/odyssey)
