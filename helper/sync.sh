#!/bin/bash

if test -f /.buildenv ; then
    echo "sync disabled inside build environment."
    exit 0
fi

exec /bin/sync.bin $*
