#!/bin/bash -e

cmd_install() {
    ../../lib/mbr.sh wipe /dev/sdb
    ../../lib/mbr.sh part_add /dev/sdb 2 '' '' 0x83 D2

    sfdisk -d /dev/sdb
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"