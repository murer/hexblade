#!/bin/bash -e

function cmd_install() {
    ../../lib/mbr.sh wipe /dev/sdb
    ../../lib/mbr.sh part_add /dev/sdb 1 0 0 0x83
    ../../lib/mkfs.sh ext4 /dev/sdb1 HEXBLADE

    mkdir /mnt/hexblade
    mkdir -p /mnt/hexblade/system
    mount /dev/sdb1 /mnt/hexblade/system
    
    ../../lib/strap.sh strap br
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"