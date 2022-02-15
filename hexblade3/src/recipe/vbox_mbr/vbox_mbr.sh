#!/bin/bash -e

cmd_install() {
    ../../lib/mbr.sh wipe /dev/sdb
    ../../lib/mbr.sh part_add /dev/sdb 2 0 +2G 0x83
    ../../lib/mbr.sh part_add /dev/sdb 3 0 0 0x83

    #sfdisk -d /dev/sdb
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"