#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh key_check master

    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 0 8300 'PARTCRYPT'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}2" master
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" MAINCRYPTED master
    
    ../../lib/util/lvm.sh format /dev/mapper/MAINCRYPTED MAINLVM
    ../../lib/util/lvm.sh add MAINLVM MAINSWAP 1G
    ../../lib/util/lvm.sh add MAINLVM MAINROOT 12G
    ../../lib/util/lvm.sh add MAINLVM MAINDATA '100%FREE'

    ../../lib/util/mkfs.sh swap /dev/mapper/MAINLVM-MAINSWAP
    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    ../../lib/util/mkfs.sh ext4 /dev/mapper/MAINLVM-MAINROOT HEXROOT
    ../../lib/util/mkfs.sh ext4 /dev/mapper/MAINLVM-MAINDATA HEXDATA

    ../../lib/util/lvm.sh close MAINLVM
    ../../lib/util/crypt.sh close MAINCRYPTED
    ../../lib/util/crypt.sh dump "${HEX_TARGET_DEV}2"
}

function cmd_crypt_open() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    [[ ! -d /mnt/hexblade/system ]]    
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" MAINCRYPTED master
    ../../lib/util/lvm.sh open MAINLVM 
}

function cmd_mount() {
    cmd_crypt_open
    mkdir -p /mnt/hexblade/system
    mount /dev/mapper/MAINLVM-MAINROOT /mnt/hexblade/system
    mkdir -p /mnt/hexblade/system/localdata
    mount /dev/mapper/MAINLVM-MAINDATA /mnt/hexblade/system/localdata  
}

function cmd_crypt_close() {
    ../../lib/util/lvm.sh close MAINLVM
    ../../lib/util/crypt.sh close MAINCRYPTED
}

function cmd_umount() {
    umount -R /mnt/hexblade/system
    rmdir /mnt/hexblade/system
    cmd_crypt_close
}

function cmd_bak_create() {
    cmd_crypt_open
    local hex_bak_tag="${1?'backup tag'}"
    ../../pack/util/bak.sh create min_crypt_mbr "$hex_bak_tag" HEXBLADE
    cmd_crypt_close
}

function cmd_bak_restore() {
    cmd_crypt_open
    local hex_bak_tag="${1?'backup tag'}"
    ../../pack/util/bak.sh restore min_crypt_mbr "$hex_bak_tag" HEXBLADE
    cmd_crypt_close
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

# function cmd_from_scratch() {
#     cmd_disk
#     cmd_mount
#     cmd_strap
#     cmd_base
#     cmd_boot
#     ../../lib/util/installer.sh umount
# }

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"