# BCA Queries

This setup gives you access to the high-availability PostgreSQL database for querying the Cardano blockchain.

## Start & Stop

In a terminal, run the following command in this directory:

```sh
docker-compose up -d
```

To stop the service, run the following command:

```sh
docker-compose down
```


## Troubleshooting

### I want to change the port on my local machine through which I can access PostgreSQL

Currently, the local port on which PostgreSQL is available on your machine is set to `5432`. This might clash with your local setup.

You can change the port setting in the `docker-compose.yml` file:

```yaml
    ports:
      - "5432:35432"
```

change the first part and keep the rest: e.g. "17432:35432"

