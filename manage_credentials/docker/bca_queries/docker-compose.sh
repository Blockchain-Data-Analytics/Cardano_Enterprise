#!/usr/bin/env bash

cat <<EOF 
name: bca_queries

services:

  # WireGuard VPN service
  wireguard:
    image: linuxserver/wireguard:latest
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    environment:
      - LOG_CONFS=true
      - TZ=Etc/UTC
    volumes:
      - ./wg-config:/config
    ports:
      - "${LOCPORT}:35432"
      - 5480:80
    restart: unless-stopped

  redir:
    image: codieplusplus/redir_docker:latest
    depends_on:
      - wireguard
    restart: unless-stopped
    network_mode: service:wireguard
    # redir gives access to IP:port on this host on port 35432
    command: /home/user/redir -n -l info -t 30 :35432 ${SRVIP}:${SRVPORT}

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin4
    environment:
      - PGADMIN_DEFAULT_EMAIL=bca@sbclab.net
      - PGADMIN_DEFAULT_PASSWORD=<create anew>
    depends_on:
      - redir
    network_mode: service:wireguard
    volumes:
      - ./pgadmin-data/:/var/lib/pgadmin/

EOF
