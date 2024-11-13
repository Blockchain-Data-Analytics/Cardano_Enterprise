#!/bin/sh

set -e

BASEP=$(dirname ${BASH_SOURCE[0]})

FNAME="pg_accounts.json"
CONFIG=${BASEP}/../${FNAME}
BACKUP=${BASEP}/../backup/${FNAME}-$(date -Iseconds)

# reserve user credentials
NOW=$(${BASEP}/get_timestamp.sh)
S_NOW=$(${BASEP}/print_timestamp.sh $NOW)

URECORD=$(jq -cj --arg reserved $NOW --arg reserved_readable $S_NOW \
   "( .pgaccounts | map(select(.status == \"free\"))[0] ) | .status |= \"inuse\" | .reserved |= \$reserved | .reserved_readable |= \$reserved_readable" \
   ${CONFIG})

UNAME=$(echo ${URECORD} | jq ".username")

if [ -z "$UNAME" -o "$UNAME" = "null" ]; then
    exit 1
fi

# output new json
tmpf=$(mktemp)
cp -f ${CONFIG} ${BACKUP}
jq "( .pgaccounts.[] | select(.username == ${UNAME}) ) = ${URECORD}" ${CONFIG} > "${tmpf}" && mv "${tmpf}" ${CONFIG}

echo $URECORD
