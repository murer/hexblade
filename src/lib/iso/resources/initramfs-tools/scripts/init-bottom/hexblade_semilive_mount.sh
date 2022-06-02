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

# if ls /dev/disk/by-label/SEMILIVEDATA; then
#         mkdir -p /root/semilivedata
#         mount -w /dev/disk/by-label/SEMILIVEDATA /root/semilivedata
# fi

# echo aaaa

# sh

if grep 'hexcryptdata=' /proc/cmdline; then
        hexblade_cryptdata_devid="$(sed 's/.*hexcryptdata=\([A-Za-z0-9\_\-]\+\).*/\1/g' /proc/cmdline)"
        mkdir -p /root/livedata
        mount -w "/dev/disk/by-uuid/$hexblade_cryptdata_devid" /root/livedata
fi


