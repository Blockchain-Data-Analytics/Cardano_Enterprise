#!/usr/bin/env bash

cat <<EOF
[Interface]
PrivateKey = ${LOCPRIVKEY}
Address = ${LOCADDR}/32

[Peer]
PublicKey = ${PEERPUBKEY}
PresharedKey = ${SHRSECR}
AllowedIPs = ${ALLOWIP}
Endpoint = ${ENDADDR}:${ENDPORT}
PersistentKeepalive = 25
EOF
