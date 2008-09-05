#!/bin/bash

OUTPUT=`uname.bin $*`

if test -f /.kernelversion ; then
  MREL=`cat /.kernelversion`
fi

if test -z "$MREL" -a -L /usr/src/linux -a -d /usr/src/linux ; then
    MREL=`readlink /usr/src/linux`
    MREL=${MREL#linux}
    MREL=${MREL#-}
    uarch=`uname.bin -m`
    # taken from kernel-source
    arch=$(echo $uarch \
           | sed -e s/i.86/i386/  -e s/sun4u/sparc64/ \
                 -e s/arm.*/arm/  -e s/sa110/arm/ \
                 -e s/s390x/s390/ -e s/parisc64/parisc/ \
                 -e s/ppc.*/powerpc/)
    flavor="$(
        cd /usr/src/linux-$MREL/arch/$arch
        set -- defconfig.*
        [ -e defconfig.default ] && set -- defconfig.default
        echo ${1/defconfig.}
    )"
    test -n "$flavor" && MREL="$MREL-$flavor"
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
