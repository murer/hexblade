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

echo bbbb

sh

# if grep 'hexsemilivedecrypt=' /proc/cmdline; then
#         hexblade_semilive_decrypt="$(sed 's/.*hexsemilivedecrypt=\([A-Za-z0-9\_\-]\+\).*/\1/g' /proc/cmdline)"
#         cryptsetup open "/dev/disk/by-uuid/$hexblade_semilive_decrypt" SEMILIVECRYPTED
# fi



