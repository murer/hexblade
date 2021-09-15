#!/bin/sh 

set -e

PREREQ=""

# Output pre-requisites
prereqs()
{
        echo "$PREREQ"
}

case "$1" in
    prereqs)
        prereqs
        exit 0
        ;;
esac

set -x

if ls /dev/disk/by-label/SEMILIVEDATA; then
        mkdir -p /root/semilivedata
        mount -r /dev/disk/by-label/SEMILIVEDATA /root/semilivedata
fi

#sh


