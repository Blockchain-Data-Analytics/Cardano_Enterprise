#!/usr/bin/env bash

# prepare VPN and credentials to access BCA Queries

if [ $# -lt 2 ]; then
    echo "call: $0 <region: EU | US> <user email>"
    exit 1
fi

set -xe

# set the product identifier
PRODUCT=bca_queries

umask 0027

PROXY=""
REGION=$1
USEREMAIL=$2

case $1 in
  EU)
    PROXY=proxyEU;;
  US)
    PROXY=proxyUS;;
esac

if [ -z "$PROXY" ]; then
    echo "unknown region"
    exit 1
fi

SED=$(which gsed || true)
if [ -z "${SED}" ]; then
    SED=sed
fi


# 1) setup VPN to proxy
SETTINGS=$(./scripts/configure_connection.sh ${PROXY})
[ $? -eq 1 ] && { echo "Failure"; exit 1; }

eval "${SETTINGS}"

IDENTIFIER=$(echo "${LOCPUBKEY:0:8}" | ${SED} -e 's/\+/-/g;s|/|_|g;')
echo $IDENTIFIER


# 2) get PostgreSQL credentials
PGCREDS=$(./scripts/get_free_pg_account.sh)

PGUSER=$(echo $PGCREDS | jq ".username")
PGPASSWORD=$(echo $PGCREDS | jq ".password")

export LOCPORT=5432
test -n "${SRVIP}" || { echo "\$SRVIP missing"; exit 1; }
test -n "${SRVPORT}" || { echo "\$SRVPORT missing"; exit 1; }
test -n "${WG0_CONF}" || { echo "\$WG0_CONF missing"; exit 1; }

# 3) make package as docker image
RESULT=$(../docker/${PRODUCT}/prepare.sh)

FZIP=$(echo "${RESULT}" | $SED -ne 's/result: \(.*\.zip\)$/\1/p')
test -n "${FZIP}" || { echo "\$FZIP missing"; exit 1; }

TGTDIR=./store/${PRODUCT}/${IDENTIFIER}
mkdir -vp ${TGTDIR}
mv $FZIP ${TGTDIR}/

KEYBASE=$(which keybase || true)
[ -n "${KEYBASE}" ] && { keybase chat send bcdataanalytics "setup BCA Queries in region ${REGION} with identifier '${IDENTIFIER}' for user ${USEREMAIL}." || true; }


# 4) message the user

cat << EOM > ./messages/${PRODUCT}-${IDENTIFIER}.txt
From: BCA Team <bca@sbclab.net>
To: ${USEREMAIL}
Subject: BCA setup of ${PRODUCT} is ready
Content-Type: text/plain

Welcome to BCA Queries

We have prepared all necessary networking and credentials for you to connect to our servers in region ${REGION}.

Download the prepared docker image: https://store.bca.sbclab.net/${PRODUCT}/${IDENTIFIER}/${FZIP}

and unpack it on your computer.


## starting or stopping

Then, launch the VPN connection in the unpacked directory (run this in a terminal):

docker-compose up

and the services are brought up.

To stop the services, run in the same directory from a terminal:

docker-compose down


## pgAdmin4 database interface

Now, you can open https://localhost:5480 to connect to pgAdmin4/PostgreSQL.

(pgAdmin will ask for a user: enter username = "bca@sbclab.net" and password = "<create anew>")

Create a new server connection and enter:

hostname = "localhost" and port = "35432"

username = ${PGUSER} with password = ${PGPASSWORD} (allow pgAdmin to store it)

with the default, maintenance database = "mainnet"

REMARK: pgAdmin will store some information in the current directory under "pgadmin-data" so when you restart the other day it has remembered your configurations


## connecting your software to PostgreSQL

The Docker image also listens on port 5432 on "localhost". Direct any software that wants to access PostgreSQL to this port and use the credentials as above:

username = ${PGUSER} with password = ${PGPASSWORD} and database = "mainnet"


If you have questions, please feel free to write us at <a href="mailto:bca@sbclab.net">bca@sbclab.net</a>.
And, we would also love to hear your feedback to improve this service.

Have a great time!

BCA Team

EOM

if [ $(whoami) = "bca" ]; then
    cat ./messages/${PRODUCT}-${IDENTIFIER}.txt | sendmail ${USEREMAIL}
else
    echo "keeping email message in: ./messages/${PRODUCT}-${IDENTIFIER}.txt"
fi

exit 0
