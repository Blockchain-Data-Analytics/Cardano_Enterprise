#!/bin/sh

# outputs the server's networking details

if [ $# -lt 1 ]; then
    echo "call: $0 <network>"
    exit 1
fi

BASEP=$(dirname ${BASH_SOURCE[0]})

CONFIG=${BASEP}/../config_bca.json

if [ ! -e ${CONFIG} ]; then
    echo "configuration file missing"
    exit 1
fi

jq ".networks .[] | select(.name==\"$1\") | pick(.name,.hostname,.subnet,.endaddr,.pgport)"  ${CONFIG}
