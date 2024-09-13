
the various products need defined configuration and access credentials.

bca_queries:
- one VPN setup on proxy machine (EU, bca10) or (US, bca7)
- PostgreSQL user & password (with login rights, max 1 connection); also for pgCat

## networks

netA   : VPN network on bca1 (pipeline A, EU & US)
netBeu : VPN network on bca3 (pipeline B, EU)
netBus : VPN network on bca4b (pipeline B, US)

proxyEU : VPN network on bca10 (pipeline A & B, EU)
proxyUS : VPN network on bca7 (pipeline A & B, US)

