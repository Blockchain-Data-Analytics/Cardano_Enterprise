
# BCA Queries

this provides a Docker image with Wireguard VPN setup with credentials matching the one on the server.

- provides a point-to-point VPN connection to BCA's proxy server
- forwards the server's PostgreSQL access port to the local machine:
   - localhost:5432 can be accessed


## references:

- https://github.com/linuxserver/docker-wireguard
- https://github.com/troglobit/redir


## preparation:

```sh
# the wireguard configuration
# in env var: \$WG0_CONF

# the server\'s PostgreSQL endpoint
SRVIP="10.42.42.1"
SRVPORT="5432"
# the locally exported PostgreSQL port
LOCPORT="5432"

export WG0_CONF SRVIP SRVPORT LOCPORT

./prepare.sh
```

This outputs a zip (bca_queries-<random>.zip, ~ 4kB) which can be sent to the user along with the user credentials to login to PostgreSQL.

The script also sends the `wg set` command that configures the Wireguard interface to the server through ssh.


## start:

```sh
docker-compose up
```

## stop:

```sh
docker-compose down
```
