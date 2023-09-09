#!/bin/bash -xe

function cmd_format() {
    ls "$HEX_TARGET_DEV"
    ../../lib/util/crypt.sh key_check iso
    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition' 
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 +6G 8300 'PARTCRYPTEDROOT'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 3 0 0 8300 'PARTCRYPTEDDATA'
    gdisk -l "$HEX_TARGET_DEV"

    ../../lib/util/efi.sh format "${HEX_TARGET_DEV}1"
    
    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}2" iso 1
    ../../lib/util/crypt.sh format "${HEX_TARGET_DEV}3" iso 1

    # ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}2" iso 0
    # ../../lib/util/crypt.sh pass_add "${HEX_TARGET_DEV}3" iso 0

    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}2" LIVECRYPTEDROOT iso
    ../../lib/util/crypt.sh open "${HEX_TARGET_DEV}3" PARTCRYPTEDDATA iso
    
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDROOT LIVECRYPTEDROOT
    ../../lib/util/mkfs.sh ext4 /dev/mapper/PARTCRYPTEDDATA PARTCRYPTEDDATA

    ../../lib/util/crypt.sh close LIVECRYPTEDROOT iso
    ../../lib/util/crypt.sh close LIVECRYPTEDDATA iso
    

    # ../../lib/util/crypt.sh pass_add "${hex_loop_dev}p2" iso 0
    # ../../lib/util/crypt.sh open "${hex_loop_dev}p2" LIVECRYPTEDROOT iso
    # ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDROOT LIVECRYPTEDROOT
    # ../../lib/util/crypt.sh close LIVECRYPTEDROOT iso
    
    # ../../lib/util/crypt.sh pass_add "${hex_loop_dev}p3" iso 0
    # ../../lib/util/crypt.sh open "${hex_loop_dev}p3" LIVECRYPTEDDATA iso
    # ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDDATA LIVECRYPTEDDATA
    # ../../lib/util/crypt.sh close LIVECRYPTEDDATA iso
}

function cmd_from_iso() {
    ls "$HEX_TARGET_DEV"
    
    ./live_crypt.sh deiso /mnt/hexblade/iso/hexblade.iso
    # cmd_usb_mount
    # ./live_crypt.iso cmd_rsync
    
    # export HEX_TARGET_DEV="$(losetup --list --raw --output NAME,BACK-FILE --noheadings | grep "/mnt/hexblade/live-crypted/block$" | cut -d" " -f1)"

    # cmd_decrypt

    # cmd_grub
    # cmd_sparse_umount
    # cmd_sparse_to_vmdk

    # du -hs /mnt/hexblade/live-crypted/block
    # du -hs --apparent-size /mnt/hexblade/live-crypted/block
    
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"