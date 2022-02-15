#!/bin/bash -e

function cmd_config_check() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
}

function cmd_install() {
    cmd_config_check

    ../../lib/mbr.sh wipe "$HEX_TARGET_DEV"
    ../../lib/mbr.sh part_add "$HEX_TARGET_DEV" 1 0 0 0x83
    ../../lib/mkfs.sh ext4 "${HEX_TARGET_DEV}1" HEXBLADE

    mkdir /mnt/hexblade
    mkdir -p /mnt/hexblade/system
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/system
    
    ../../lib/strap.sh strap br
}



set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"