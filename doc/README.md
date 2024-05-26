# Cardano Enterprise Db-sync

## 00 Features

* a mapping of Cardano blockchain data to the relational database PostgreSQL

* providing user access per region (eu-west, us-east)

* enabling data-driven business processes with blockchain interoperability

* safety by design: redundant databases

* flexibility: subscribe to level of services as you need

* scalability: as your business grows so does our service

* pay-as-you-go: commit to a period of time, with renewal


## 01 Infrastructure

We maintain a redundant infrastructure to minimise the risk of instance downtime or interruption of data feed delivery.

see [01 Infrastructure](01_Infrastructure.md)


## 02 Virtual Private Network

The computers in our setup are connected through a VPN (_WireGuard_).

see [02 VPN](02_VPN.md)


## 03 Software setup

Description of compiling and setup of the necessary software components (_node_ and _Db-sync_) is described in [03 Software](03_Software.md).


## 04 High availability and risks

We discuss aspects of our high availability setup and the risks and mitigations in [04 High availability](04_High_availability.md).


## 05 Demonstrations

Videos of capturing output in a terminal that demonstrates the update from the blockchain in our two independent pipelines of _Db-sync_ and the downstream database replica.

Also shown is the behaviour in case of one database getting inaccessible and how the proxy automatically switches to using the other one.

see [05 Demonstration](05_Demonstration_M1.md)

## 06 Monitoring

Description of our monitoring stack: [06 Monitoring](06_Monitoring.md)