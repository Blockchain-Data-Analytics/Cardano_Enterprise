#!/bin/sh

if [ $# -lt 1 ]; then
    echo "call: $0 <timestamp>"
    exit 1
fi

OS=$(uname -s)

case $OS in
    Linux)
        TZ=UTC date -Iseconds -d @"$1"
        ;;
    Darwin)
        TZ=UTC date -Iseconds -r "$1"
esac
