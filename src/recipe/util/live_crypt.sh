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

function cmd_from_iso() {
    local hexblade_iso="${1?'iso file'}"
    ../../lib/iso/iso.sh deiso "$hexblade_iso"
    cmd_disk
    # ../../lib/iso/iso.sh decompress
    # ../../lib/util/installer.sh chr passwd ubuntu
    # ../../lib/iso/iso.sh iso
    # ../../lib/iso/iso.sh sha256
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"