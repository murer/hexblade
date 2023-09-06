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



