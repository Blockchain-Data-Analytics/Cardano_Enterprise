#!/usr/bin/env bash

set -e

BASEP=$(dirname ${BASH_SOURCE[0]})

# settings

## exposed local port for PostgreSQL connections
LOCPORT=${LOCPORT:?missing}

## the PostgreSQL server address and port
SRVIP=${SRVIP:?missing}
SRVPORT=${SRVPORT:?missing}

LOCPUBKEY=${LOCPUBKEY:?missing}

export SRVIP SRVPORT LOCPORT LOCPUBKEY

# prepare wireguard configuration

WG0_CONF=${WG0_CONF:?missing}

echo -e "${WG0_CONF}" > ${BASEP}/package/wg-config/wg_confs/wg0.conf

# prepare docker-compose.yml

${BASEP}/docker-compose.sh > ${BASEP}/package/docker-compose.yml


# copy README file

cp -f ${BASEP}/README_package.md ${BASEP}/package/README.md

SED=$(which gsed || true)
if [ -z "${SED}" ]; then
    SED=sed
fi
TRGDIR=$(echo "bca_queries-${LOCPUBKEY:0:8}" | ${SED} -e 's/\+/-/g;s|/|_|g;')

umask 022
mkdir -v ${TRGDIR}

cp -r ${BASEP}/package/* ${TRGDIR}/

zip -3 -m -r -q ${TRGDIR}.zip ${TRGDIR}

echo "result: ${TRGDIR}.zip"
