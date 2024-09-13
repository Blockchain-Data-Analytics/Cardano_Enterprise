#!/bin/sh

BASEP=$(dirname $0)

cd ${BASEP}

if [ -e docker-compose.yml ]; then
    docker-compose up -d
fi


