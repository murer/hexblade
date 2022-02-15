#!/bin/bash -xe

function cmd_config_check() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
}

function cmd_disk() {
    ../../lib/mbr.sh wipe "$HEX_TARGET_DEV"
    ../../lib/mbr.sh part_add "$HEX_TARGET_DEV" 1 0 0 0x83
    ../../lib/mkfs.sh ext4 "${HEX_TARGET_DEV}1" HEXBLADE
}

function cmd_mount() {
    [[ ! -d /mnt/hexblade/system ]]    
    mkdir -p /mnt/hexblade/system
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/system    
}

function cmd_install() {
    [[ -d /mnt/hexblade/system ]] 
    ../../lib/strap.sh strap br
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"