#!/bin/bash -xe

function cmd_config_check() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    HEX_TARGET_USER="${HEX_TARGET_USER:-hex}"
    if [[ "x$HEX_TARGET_PASS" == "x" ]]; then
        echo 'password is required: export HEX_TARGET_PASS="$(openssl passwd -6)"'
        false
    fi
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

function cmd_umount() {
    umount -R /mnt/hexblade/system
    rmdir /mnt/hexblade/system
}

function cmd_base() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh strap br
    ../../lib/basesys/basesys.sh hostname hex
    ../../lib/basesys/basesys.sh base
    ../../lib/basesys/basesys.sh kernel
    ../../lib/util/user.sh add "$HEX_TARGET_USER" "$HEX_TARGET_PASS"
    ../../lib/util/installer.sh uchr hex sudo -E /installer/hexblade/pack/util/tools.sh install
}

function cmd_boot() {
    ../../lib/util/fstab.sh gen
    ../../lib/util/boot.sh boot "$HEX_TARGET_DEV"
}

function cmd_from_scratch() {
    cmd_disk
    cmd_mount
    cmd_base
    cmd_boot
    cmd_umount
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"