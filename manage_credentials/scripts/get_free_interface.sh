#!/bin/sh

if [ $# -lt 1 ]; then
    echo "call: $0 <network>"
    exit 1
fi

set -e

NET=$1

DAYS_EXPIRY=30

BASEP=$(dirname ${BASH_SOURCE[0]})

FNAME="config_bca.json"
CONFIG=${BASEP}/../${FNAME}
BACKUP=${BASEP}/../backup/${FNAME}-$(date -Iseconds)

# get first free interface (name)
IFNAME=$(jq ".networks .[] | select(.name==\"$NET\") | .interfaces | map(select(.status == \"free\"))[0].name"  ${CONFIG})

if [ -z "$IFNAME" ]; then
    exit 1
fi

# reserve interface
NOW=$(${BASEP}/get_timestamp.sh)
EXPIRY=$(($NOW + $DAYS_EXPIRY * 24 * 3600))
S_NOW=$(${BASEP}/print_timestamp.sh $NOW)
S_EXPIRY=$(${BASEP}/print_timestamp.sh $EXPIRY)

NEWIF=$(jq -cj --arg launched $NOW --arg launched_readable $S_NOW --arg expiry $EXPIRY --arg expiry_readable $S_EXPIRY \
   "( .networks.[] | select(.name == \"$NET\") | .interfaces.[] | select(.name == ${IFNAME}) ) | .status |= \"inuse\" | .launched |= \$launched | .expiry |= \$expiry | .launched_readable |= \$launched_readable | .expiry_readable |= \$expiry_readable " \
   ${CONFIG})


# output new json
tmpf=$(mktemp)
cp -f ${CONFIG} ${BACKUP}
jq "(.networks .[] | select(.name==\"$NET\") | .interfaces.[] | select(.name == ${IFNAME}) ) = ${NEWIF}" ${CONFIG} > "${tmpf}" && mv "${tmpf}" ${CONFIG}

echo $NEWIF
