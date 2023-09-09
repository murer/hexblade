#!/bin/bash -xe

function cmd_format() {
    ls "$HEX_TARGET_DEV"
    ../../lib/util/crypt.sh key_check iso
    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition' 
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 +6G 8300 'LIVECRYPTEDROOT'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 3 0 0 8300 'LIVECRYPTEDDATA'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    
    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}2" iso 1
    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}3" iso 1

    ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}2" iso 0
    ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}3" iso 0

    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" LIVECRYPTEDROOT iso
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}3" LIVECRYPTEDDATA iso
    
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDROOT LIVECRYPTEDROOT
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDDATA LIVECRYPTEDDATA

    ../../lib/util/crypt.sh close LIVECRYPTEDROOT iso
    ../../lib/util/crypt.sh close LIVECRYPTEDDATA iso
}

function cmd_usb_mount() {
    ls "$HEX_TARGET_DEV"
    [ ! -d /mnt/hexblade/cryptiso ]
    mkdir -p /mnt/hexblade/cryptiso/efi
    mount "${HEX_TARGET_DEV}1" /mnt/hexblade/cryptiso/efi
    mkdir -p /mnt/hexblade/cryptiso/image
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" LIVECRYPTEDROOT iso
    mount /dev/mapper/LIVECRYPTEDROOT /mnt/hexblade/cryptiso/image
}

function cmd_usb_umount() {
    umount /mnt/hexblade/cryptiso/image
    ../../lib/util/crypt.sh close LIVECRYPTEDROOT
    umount /mnt/hexblade/cryptiso/efi
    rmdir /mnt/hexblade/cryptiso/image /mnt/hexblade/cryptiso/efi /mnt/hexblade/cryptiso
}

function cmd_from_iso() {
    ls "$HEX_TARGET_DEV"
    
    ./live_crypt.sh deiso /mnt/hexblade/iso/hexblade.iso
    cmd_usb_mount
    ./live_crypt.sh rsync
    sync

    ./live_crypt.sh customize
    sync

    ./live_crypt.sh decrypt
    sync

    ./live_crypt.sh grub
    sync

    cmd_usb_umount
    sync
    
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"