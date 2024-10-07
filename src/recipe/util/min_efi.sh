#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    # ../../lib/util/crypt.sh key_check master

    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 0 8300 'MAIN'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    ../../lib/util/mkfs.sh ext4 "${HEX_TARGET_DEV}2" MAIN
}

function cmd_mount() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    mkdir -p /mnt/hexblade/system
    mount "${HEX_TARGET_DEV}2" /mnt/hexblade/system
    mkdir -p /mnt/hexblade/system/boot/efi
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/system/boot/efi
}

function cmd_umount() {
    umount -R /mnt/hexblade/system
    rmdir /mnt/hexblade/system
}

function cmd_strap() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh strap br
}

function cmd_base() {
    [[ "x$HEX_TARGET_USER" != "x" ]]
    [[ "x$HEX_TARGET_PASS" != "x" ]] # export HEX_TARGET_PASS="$(openssl passwd -6)"
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh hostname hex
    ../../lib/basesys/basesys.sh base
    ../../lib/basesys/basesys.sh keyboard
    ../../lib/basesys/basesys.sh kernel
    ../../lib/util/user.sh add "$HEX_TARGET_USER" "$HEX_TARGET_PASS"
    ../../lib/util/installer.sh uchr hex sudo -E /installer/hexblade/pack/util/tools.sh install
}

function cmd_boot() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh crypttab_start
    ../../lib/util/crypt.sh crypttab_add MAINCRYPTED master
    ../../lib/util/fstab.sh gen
    ../../lib/util/boot.sh boot "$HEX_TARGET_DEV"
}

function cmd_from_scratch() {
    cmd_disk
    cmd_mount
    cmd_strap
    cmd_base
    cmd_boot
    cmd_umount
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"