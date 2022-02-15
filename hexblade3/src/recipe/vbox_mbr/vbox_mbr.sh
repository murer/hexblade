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

function cmd_base() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh strap br
    ../../lib/basesys/basesys.sh base
    ../../lib/basesys/basesys.sh kernel
    ../../lib/util/user.sh hex '$6$yezbceQeUn3lVZOI$M7N0ce6X5ZCBzLiquhCsUnVhnEkBEf/YQVm5fucECGIfacDK.XgXTfbZdl4Ah9QwJ/oZ85//7S7mZRC0PZZtm1'
}

function cmd_install() {
    mkdir -p /mnt/hexblade/system/installer/hexblade
    rsync -av --delete --exclude .git ../../ /mnt/hexblade/system/installer/hexblade/
    arch-chroot /mnt/hexblade/system /installer/hexblade/pack/util/tools.sh install
}

function cmd_boot() {
    ../../lib/util/boot.sh boot "$HEX_TARGET_DEV"
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"