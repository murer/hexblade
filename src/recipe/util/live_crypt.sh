#!/bin/bash -xe

function cmd_disk() {
    [[ "x$HEX_TARGET_DEV" != "x" ]]
    ../../lib/util/crypt.sh key_check master

    ../../lib/util/gpt.sh wipe "$HEX_TARGET_DEV"
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 1 0 +512M EF00 'EFI system partition'
    ../../lib/util/gpt.sh part_add "$HEX_TARGET_DEV" 2 0 0 8300 'PARTCRYPT'
    gdisk -l "$HEX_TARGET_DEV"

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
    #../../lib/iso/iso.sh decompress    
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
    rsync -av --delete /mnt/hexblade/image/ /mnt/hexblade/cryptiso/image/
    mkdir -p /mnt/hexblade/cryptiso/efi/efi/boot/
    #rsync -av --delete /mnt/hexblade/image/EFI/ /mnt/hexblade/cryptiso/efi/boot/
    #cp /mnt/hexblade/image/isolinux/bootx64.efi /mnt/hexblade/cryptiso/efi/efi/boot/
}

# function cmd_install() {
#     ../../lib/cryptlive/cryptlive.sh install
#     HEXBLADE_LIVE_DISABLE_ADDUSER=true ../../lib/iso/iso.sh install
#     ../../lib/iso/iso.sh compress
# }

function cmd_grub() {
    hexblade_crypted_uuid="$(sudo blkid -o value -s UUID "${HEX_TARGET_DEV}2")"
    hexblade_crypted_id="$(echo "$hexblade_crypted_uuid" | tr -d '-')"
    hexblade_root_uuid="$(sudo blkid -o value -s UUID /dev/mapper/LIVELVM-LIVEROOT)"
    hexblade_root_id="$(echo "$hexblade_root_uuid" | tr -d '-')"
    cd /mnt/hexblade/cryptiso/image/
    echo "
    search --set=root --file /ubuntu
    insmod all_video
    insmod part_gpt
    insmod cryptodisk
    insmod luks
    insmod lvm
    insmod ext2
    set default=\"0\"
    set timeout=3
    menuentry \"Haxblade Crypt Live\" {
        cryptomount -u $hexblade_crypted_id
        search --no-floppy --fs-uuid --set $hexblade_root_uuid
        linux /casper/vmlinuz boot=casper bootfrom=(lvm/LIVELVM-LIVEROOT) nopersistent verbose nosplash ---
        initrd /casper/initrd
    }
    " > isolinux/grub.cfg
    grub-mkstandalone \
        --format=x86_64-efi \
        --output=isolinux/bootx64.efi \
        --locales="" \
        --fonts="" \
        "boot/grub/grub.cfg=isolinux/grub.cfg"
   cd -
   cp /mnt/hexblade/cryptiso/image/isolinux/bootx64.efi /mnt/hexblade/cryptiso/efi/efi/boot/
}

function cmd_from_iso() {
    cmd_deiso "$@"
    cmd_disk
    cmd_mount
    cmd_rsync
    cmd_umount
    # cmd_iso
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"