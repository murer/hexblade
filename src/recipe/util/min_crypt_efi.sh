#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    [[ "x$HEX_TARGET_DEV_EFI" != "x" ]]
    [[ "x$HEX_TARGET_DEV_SWAP" != "x" ]]
    [[ "x$HEX_TARGET_DEV_ROOT" != "x" ]]
    
    ../../lib/util/crypt.sh key_check master

    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 +32G 8300 'SWAP'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 3 0 0 8300 'PARTCRYPT'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/crypt.sh format "$HEX_TARGET_DEV_SWAP" master 1
    ../../lib/util/crypt.sh pass_add "$HEX_TARGET_DEV_SWAP" master 0
    ../../lib/util/crypt.sh open "$HEX_TARGET_DEV_SWAP" MAINSWAP master

    ../../lib/util/crypt.sh format "$HEX_TARGET_DEV_ROOT" master 1
    ../../lib/util/crypt.sh pass_add "$HEX_TARGET_DEV_ROOT" master 0
    ../../lib/util/crypt.sh open "$HEX_TARGET_DEV_ROOT" MAINCRYPTED master
    
    ../../lib/util/mkfs.sh swap /dev/mapper/MAINSWAP MAINSWAP
    ../../lib/util/efi.sh format "$HEX_TARGET_DEV_EFI"
    ../../lib/util/mkfs.sh ext4 /dev/mapper/MAINCRYPTED MAINCRYPTED

    ../../lib/util/crypt.sh close MAINCRYPTED
    ../../lib/util/crypt.sh close MAINSWAP
    ../../lib/util/crypt.sh dump "$HEX_TARGET_DEV_SWAP"
    ../../lib/util/crypt.sh dump "$HEX_TARGET_DEV_ROOT"
}

function cmd_crypt_open() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    [[ ! -d /mnt/hexblade/system ]]    
    ../../lib/util/crypt.sh open "$HEX_TARGET_DEV_SWAP" MAINSWAP master
    ../../lib/util/crypt.sh open "$HEX_TARGET_DEV_ROOT" MAINCRYPTED master
}

function cmd_mount() {
    cmd_crypt_open
    swapon /dev/mapper/MAINSWAP
    mkdir -p /mnt/hexblade/system
    mount /dev/mapper/MAINCRYPTED /mnt/hexblade/system
    mkdir -p /mnt/hexblade/system/boot/efi
    mount "$HEX_TARGET_DEV_EFI" /mnt/hexblade/system/boot/efi
}

function cmd_crypt_close() {
    ../../lib/util/crypt.sh close MAINCRYPTED
    ../../lib/util/crypt.sh close MAINSWAP
}

function cmd_umount() {
    umount -R /mnt/hexblade/system
    rmdir /mnt/hexblade/system
    swapoff /dev/mapper/MAINSWAP
    cmd_crypt_close
}

function cmd_download_tcp() {
    cd /mnt/hexblade
    ncat -vl 5005 | sudo tar xzp --acls --xattrs --same-owner -f -
    cd - 1>&2
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