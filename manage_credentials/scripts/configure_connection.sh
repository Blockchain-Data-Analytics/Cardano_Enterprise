#!/bin/sh

# sets environment variables for configuring a Wireguard VPN interface
# on networks: netA | netBeu | netBus | proxyEU | proxyUS

# selects and reserves a free interface
# outputs:
# 1) the Wireguard configuration on the server
# 2) the Wireguard configuration for the client (also in $WG0_CONF)


if [ $# -lt 1 ]; then
    echo "call: $0 <network>"
    exit 1
fi

set -e

NET=$1

BASEP=$(dirname ${BASH_SOURCE[0]})

JIFACE=$(${BASEP}/get_free_interface.sh $NET)

if [ -z "$JIFACE" ]; then
    echo "no free interface for network $NET"
    exit 1
fi

JNETWORK=$(${BASEP}/get_network.sh $NET)

if [ -z "$JNETWORK" ]; then
    echo "failed to get network infos for $NET"
    exit 1
fi

IFACE=$(echo $JIFACE | jq -r '.name')
# BCA subnet selection
SUBNET=$(echo $JNETWORK | jq -r '.subnet')
SUBSUBNET=$(echo $JIFACE | jq -r '.subsubnet')
JLOCADDR=$(echo $JIFACE | jq -r '.locaddr')
JSRVADDR=$(echo $JIFACE | jq -r '.srvaddr')
JALLOWIP=$(echo $JIFACE | jq -r '.allowip')
# the wireguard server\'s endpoint address and port
ENDADDR=$(echo $JNETWORK | jq -r '.endaddr')
ENDPORT=$(echo $JIFACE | jq -r '.endport')
# the server\'s public key
PEERPUBKEY=$(echo $JIFACE | jq -r '.peerpubkey')
# the client's address
LOCADDR="${SUBNET}${SUBSUBNET}${JLOCADDR}"
# the client's network mask
ALLOWIP="${SUBNET}${SUBSUBNET}${JALLOWIP}"
# the server\'s PostgreSQL endpoint
SRVIP="${SUBNET}${SUBSUBNET}${JSRVADDR}"
SRVPORT=$(echo $JNETWORK | jq -r '.pgport')
export LOCADDR SRVIP ALLOWIP ENDADDR ENDPORT SRVPORT PEERPUBKEY

# prepare Wireguard credentials
LOCPRIVKEY=$(wg genkey)
LOCPUBKEY=$(echo $LOCPRIVKEY | wg pubkey)
SHRSECR=$(wg genpsk)
export LOCPRIVKEY SHRSECR LOCPUBKEY

#echo "# ***** add peer to the interface on the server:"
ssh bca@${ENDADDR} "TMP=\$(mktemp); echo \"${SHRSECR}\" > \$TMP; sudo wg set ${IFACE} peer \"${LOCPUBKEY}\" preshared-key \$TMP persistent-keepalive 25 allowed-ips \"${LOCADDR}/32\"; rm \$TMP;"
echo

echo "export LOCADDR=${LOCADDR}"
echo "export SRVIP=${SRVIP}"
echo "export ALLOWIP=${ALLOWIP}"
echo "export ENDADDR=${ENDADDR}"
echo "export ENDPORT=${ENDPORT}"
echo "export SRVPORT=${SRVPORT}"
echo "export PEERPUBKEY=${PEERPUBKEY}"

echo "export LOCPRIVKEY=${LOCPRIVKEY}"
echo "export LOCPUBKEY=${LOCPUBKEY}"
echo "export SHRSECR=${SHRSECR}"

#WG0_CONF=$(${BASEP}/show_wg_config.sh)
#export WG0_CONF

echo "WG0_CONF='$(${BASEP}/show_wg_config.sh)'"
echo "export WG0_CONF"
echo
