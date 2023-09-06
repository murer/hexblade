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

# echo bbbb
# sh

sh

set -x

for k in $(ls /etc/luksparts/*.key | sed 's/\.key$\\g'); do
    echo cryptsetup open "/dev/disk/by-uuid/$k" "CRYPTED-$k"
done

sh



