#!/bin/bash

OUTPUT=`uname.bin $*`

if test -f /.kernelversion ; then
  MREL=`cat /.kernelversion`
fi

if test -z "$MREL" -a -L /usr/src/linux -a -d /usr/src/linux ; then
    MREL=$( shopt -s nullglob; set -- /lib/modules/*-default /lib/modules/* ; test -n "$1" && basename $1 )
fi

if test -z "$MREL" -a -L /usr/src/linux -a -d /usr/src/linux -a -d /usr/src/linux-obj ; then
    MVER=$(readlink /usr/src/linux)
    MVER=${MVER#linux-}
    ARCH=$(uname.bin -m)
    MFLAV=$( shopt -s nullglob; set -- /usr/src/linux-obj/$ARCH/default /usr/src/linux-obj/$ARCH/* ; test -n "$1" && basename $1 )
    test -n "$MVER" -a -n "$MFLAV" && MREL=$MVER-$MFLAV
fi

if test -z "$MREL" -a -f /usr/src/linux/Makefile ; then
    MREL=`grep "^VERSION = " /usr/src/linux/Makefile 2> /dev/null | sed -e "s/VERSION = //"`
    MREL=$MREL.`grep "^PATCHLEVEL = " /usr/src/linux/Makefile 2> /dev/null | sed -e "s/PATCHLEVEL = //"`
    MREL=$MREL.`grep "^SUBLEVEL = " /usr/src/linux/Makefile 2> /dev/null | sed -e "s/SUBLEVEL = //"`
fi

if test -z "$MREL" ; then
MREL=`grep UTS /usr/include/linux/version.h 2> /dev/null | sed -ne "s/.*\"\(.*\)\".*/\1/p;q"`
fi

if test -n "$MREL" ; then
    echo $OUTPUT | sed -e "s/[0-9]\.[0-9]\.[0-9][-.0-9a-zA-Z_]*/$MREL/"
else
    echo $OUTPUT
fi
