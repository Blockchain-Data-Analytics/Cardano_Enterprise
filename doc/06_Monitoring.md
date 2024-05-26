[back to index](README.md)

## Setup
In order to monitor the system's various parts, we use Prometheus and Grafana.
Prometheus has two parts: exporters and scrapers
Using various Prometheus exporters (see below), we export various metrics as a local web service. Each job is running on different port (eg. 9100).
Then the Prometheus scrapers, visit the aforementioned web services, extract all the metrics and ingest them in the Prometheus Database.
Using the Prometheus data (that has been ingested in the database), there are various dashboards created using Grafana.
This gives us a visual way to interpret the data, but also an alerting functionality:
- Using a [Keybase](https://keybase.io/) channel, we post messages from Grafana using a webhook, whenever an alert is triggered (eg. high CPU usage)


## Monitoring
We have various exporters running in our server that export a broad range of metrics. 
Namely:
- A [node exporter](https://github.com/prometheus/node_exporter)
  that we use to measure our servers' resources like memory, CPU and disk utilization
- A [postgres exporter](https://github.com/prometheus-community/postgres_exporter)
  that exports metrics about the Postgres database like memory usage, active sessions and transactions.
  On top of the database metrics, we have created some "business" metrics, that help us monitor some assumptions we have for the data using custom SQL queries
  (see below Block time lag")
- and a [process exporter](https://github.com/ncabatoff/process-exporter)
  that mainly monitors process uptime. We use this to verify that our Cardano node and Cardano db-sync processes are up and running


## Dashboards
Grafana can be accessed [here](https://monitoring.bca.sbclab.net/) (it requires authentication)
There are also some public dashboards that you can view:
- [Block time lag](https://monitoring.bca.sbclab.net/public-dashboards/358cf9717a3d4927a836983bc6a42003?orgId=1) 
Here you can view 2 main metrics: 
1. The difference between latest block's time and the current time
2. The difference between the block's creation time and the block's insertion time in the database
These metrics are shown across all our databases.
- A [Postgres monitoring dashboard](https://monitoring.bca.sbclab.net/d/postgresql-k8s/postgresql-database) (requires auth)
Here you can view all metrics around all our database instances.
- A [Node exporter dashboard](https://monitoring.bca.sbclab.net/d/rYdddlPWk/node-exporter-full?orgId=1&refresh=1m) (requires auth)
Depicting various metrics around the resources used by our nodes.
- A [Named processes dashboard](https://monitoring.bca.sbclab.net/d/aa0cdc9f-a76f-4c52-ae61-80f1fa52c671/named-processes?orgId=1&refresh=10s)
Showing the uptime of db-sync and node processes.
