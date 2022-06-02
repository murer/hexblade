#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh key_check master

    ../../lib/util/mbr.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/mbr.sh part_add "$HEX_TARGET_DEV" 1 0 +512M 0x0C
    ../../lib/util/mbr.sh part_add "$HEX_TARGET_DEV" 2 0 0 0x83

    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}2" master 1
    ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}2" master 0
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" LIVECRYPTED master
    
    ../../lib/util/lvm.sh format /dev/mapper/LIVECRYPTED LIVELVM
    ../../lib/util/lvm.sh add LIVELVM LIVEROOT 12G
    ../../lib/util/lvm.sh add LIVELVM LIVEDATA '100%FREE'

    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVELVM-LIVEROOT HEXLIVEROOT
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVELVM-LIVEDATA HEXLIVEDATA

    ../../lib/util/lvm.sh close LIVELVM
    ../../lib/util/crypt.sh close LIVECRYPTED
    ../../lib/util/crypt.sh dump "${HEX_TARGET_DEV}2"
}

function cmd_deiso() {
    local hexblade_iso="${1?'iso file'}"
    ../../lib/iso/iso.sh deiso "$hexblade_iso"
    ../../lib/iso/iso.sh decompress    
}

# function cmd_iso() {
#     HEXBLADE_LIVE_DISABLE_ADDUSER=true ../../lib/iso/iso.sh install
#     ../../lib/iso/iso.sh compress
#     ../../lib/iso/iso.sh iso
#     ../../lib/iso/iso.sh sha256
# }

function cmd_crypt_open() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" LIVECRYPTED master
    ../../lib/util/lvm.sh open LIVELVM 
}

function cmd_mount() {
    [[ ! -d /mnt/hexblade/cryptiso ]]
    cmd_crypt_open
    mkdir -p /mnt/hexblade/cryptiso/efi
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/cryptiso/efi
    mkdir -p /mnt/hexblade/cryptiso/image
    mount /dev/mapper/LIVELVM-LIVEROOT /mnt/hexblade/cryptiso/image
}

function cmd_crypt_close() {
    ../../lib/util/lvm.sh close LIVELVM
    ../../lib/util/crypt.sh close LIVECRYPTED
}

function cmd_umount() {
    umount /mnt/hexblade/cryptiso/image
    umount /mnt/hexblade/cryptiso/efi
    rmdir /mnt/hexblade/cryptiso/image /mnt/hexblade/cryptiso/efi /mnt/hexblade/cryptiso
    cmd_crypt_close
}

function cmd_rsync() {
    mkdir -p /mnt/hexblade/cryptiso/efi/boot/
    rsync -av --delete /mnt/hexblade/image/ /mnt/hexblade/cryptiso/image/
    rsync -av --delete /mnt/hexblade/image/EFI/ /mnt/hexblade/cryptiso/efi/boot/
}

function cmd_from_iso() {
    cmd_deiso "$@"
    cmd_disk
    cmd_mount
    # ../../lib/util/installer.sh chr passwd ubuntu
    cmd_umount
    # cmd_iso
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"