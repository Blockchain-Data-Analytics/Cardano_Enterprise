[back to index](README.md)

## Introduction

In the Cardano blockchain, hard forks occasionally occur, leading to non-backwards compatible protocol changes. When this happens, db-sync must also update its schema in a non-backwards compatible manner to remain compatible with the new protocol version. This document outlines the process for transitioning to a new db-sync version during such events.

## Process

When a new version of db-sync with breaking changes is released, we will implement the following steps:

1. **New Database Instance**:
   - A new database instance running the latest db-sync version will be created.
   - Users who sync with our databases in a streaming manner will need to reconnect and sync from scratch.
   - For those who want to connect directly to the new instance and run queries, we will provide a new set of credentials.

2. **Transition Period**:
   - There will be a 3-month transition period during which both the old and new database versions will run in parallel.
   - This allows users sufficient time to migrate to the new version.
   - During this transition period, the old version will continue to operate with redundancy, meaning we will run two instances of the old version to ensure reliability.

3. **Post-Transition**:
   - After the 3-month transition period, the old versions will be shut down.
   - The new version will gain redundancy after the transition phase ends, ensuring high availability and reliability.

Please be mindful of the transition period and plan your migration accordingly to avoid any disruptions.






