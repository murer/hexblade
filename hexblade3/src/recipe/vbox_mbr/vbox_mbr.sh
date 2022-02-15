#!/bin/bash -xe

function cmd_config_check() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
}

function cmd_disk() {
    ../../lib/util/mbr.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/mbr.sh part_add "$HEX_TARGET_DEV" 1 0 0 0x83
    ../../lib/util/mkfs.sh ext4 "${HEX_TARGET_DEV}1" HEXBLADE
}

function cmd_mount() {
    [[ ! -d /mnt/hexblade/system ]]    
    mkdir -p /mnt/hexblade/system
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/system    
}

function cmd_install() {
    [[ -d /mnt/hexblade/system ]] 
    ../../lib/basesys/basesys.sh strap br
    ../../lib/basesys/basesys.sh base
    ../../pack/util/tools.sh install
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"