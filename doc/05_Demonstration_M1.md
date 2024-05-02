[back to index](README.md)

# Demonstrations

## Live recording of databases updating from the blockchain

We are running two independent pipelines of node & Db-sync in Europe: _bca1_ and _bca3_.
We also run a replica in the US: _bca4b_.
And, for demonstration purposes, I run a local replica: _replica1_.

All these databases get updated by Db-sync whenever there is a new block available on _mainnet_.

Using some queries on the block height, i.e. _slot\_no_, we can demonstrate that the pipelines update their databases and the replica follow with short delay.

![Terminal captured showing update of block height in two independent pipelines and two replica](img/Recording_Database_Updating_Blockheights.mp4)


## Live recording of failover behaviour

Additionally to the above setup, we have setup a PostgreSQL proxy, e.g. _pgcat_, through which the queries are sent either to one pipeline _bca1_, or the second _bca3_. 

The demonstration shows that when pipeline _bca1_ stops updating its database, thus the block height for _bca1_ does not increase anymore, then the querying through the proxy still returns the latest block height as it now redirects the query to the other pipeline _bca3_.

![In case of failover the proxy redirects to the other pipeline and still returns the latest block height](img/Recording_Database_Updating_Failover.mp4)
