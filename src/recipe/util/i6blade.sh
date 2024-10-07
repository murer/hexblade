#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh key_check master

    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 +64G 8300 'SYSTEM'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 3 0 0 8300 'DATA'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}2" master 1
    ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}2" master 0
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" SYSTEMCRYPTED master
    
    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}3" master 1
    ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}3" master 0
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}3" DATACRYPTED master

    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    ../../lib/util/mkfs.sh ext4 /dev/mapper/SYSTEMCRYPTED SYSTEMCRYPTED
    ../../lib/util/mkfs.sh ext4 /dev/mapper/DATACRYPTED DATACRYPTED
}

function cmd_mount() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    mkdir -p /mnt/hexblade/system
    mount "${HEX_TARGET_DEV}2" /mnt/hexblade/system
    mkdir -p /mnt/hexblade/system/boot/efi
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/system/boot/efi
    mkdir -p /mnt/hexblade/system/localdata
    mount "${HEX_TARGET_DEV}3" /mnt/hexblade/system/localdata
}

function cmd_crypt_close() {
    ../../lib/util/crypt.sh close SYSTEMCRYPTED
    ../../lib/util/crypt.sh close DATACRYPTED
}

function cmd_umount() {
    umount -R /mnt/hexblade/system
    rmdir /mnt/hexblade/system
    cmd_crypt_close
}

function cmd_strap() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh strap br
}

function cmd_base() {
    export HEX_TARGET_USER='hex'
    export HEX_TARGET_PASS='$6$NI0AqicDKVuIhVdG$WLlVpgkjeKYxIywunabL7BrtMYVNATLjI8wE00gOVG3aXLXYyJHjHLiGeHJlXaKJyjYEe2JvIIzkpeFCBtDUR0'
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh hostname hex
    ../../lib/basesys/basesys.sh base
    ../../lib/basesys/basesys.sh keyboard
    # ../../lib/basesys/basesys.sh kernel
    ../../lib/util/user.sh add "$HEX_TARGET_USER" "$HEX_TARGET_PASS"
    ../../lib/util/installer.sh uchr hex sudo -E /installer/hexblade/pack/util/tools.sh install
}

function cmd_boot() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
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