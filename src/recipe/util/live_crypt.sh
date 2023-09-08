#!/bin/bash -xe

function cmd_deiso() {
    local hexblade_iso="${1?'iso file'}"
    ../../lib/iso/iso.sh deiso "$hexblade_iso"
    ../../lib/iso/iso.sh decompress
}

function cmd_sparse_mount() {
    [ -f /mnt/hexblade/live-crypted/block ]
    [ ! -d /mnt/hexblade/cryptiso ]
    local hex_loop_dev="$(losetup --list --raw --output NAME,BACK-FILE --noheadings | grep "/mnt/hexblade/live-crypted/block$" | cut -d" " -f1)"
    [ "x$hex_loop_dev" != "x" ] || hex_loop_dev=$(losetup -P -f --show /mnt/hexblade/live-crypted/block)
    mkdir -p /mnt/hexblade/cryptiso/efi
    mount "${hex_loop_dev}p1" /mnt/hexblade/cryptiso/efi
    mkdir -p /mnt/hexblade/cryptiso/image
    ../../lib/util/crypt.sh open "${hex_loop_dev}p2" LIVECRYPTEDROOT iso
    mount /dev/mapper/LIVECRYPTEDROOT /mnt/hexblade/cryptiso/image
}

function cmd_crypt_close() {
    ../../lib/util/lvm.sh close LIVELVM
    ../../lib/util/crypt.sh close LIVECRYPTED
}

function cmd_sparse_umount() {
    umount /mnt/hexblade/cryptiso/image
    ../../lib/util/crypt.sh close LIVECRYPTEDROOT
    umount /mnt/hexblade/cryptiso/efi
    rmdir /mnt/hexblade/cryptiso/image /mnt/hexblade/cryptiso/efi /mnt/hexblade/cryptiso
    local hex_loop_dev="$(losetup --list --raw --output NAME,BACK-FILE --noheadings | grep "/mnt/hexblade/live-crypted/block$" | cut -d" " -f1)"
    [ "x$hex_loop_dev" == "x" ] || losetup -d "$hex_loop_dev"
}

function cmd_rsync() {
    rsync -acv --delete /mnt/hexblade/image/ /mnt/hexblade/cryptiso/image/
    mkdir -p /mnt/hexblade/cryptiso/efi/efi/boot/
}

function cmd_grub() {
    [ "x$HEX_TARGET_DEV" != "x" ]
    local hexblade_crypted_uuid="$(sudo blkid -o value -s UUID "${HEX_TARGET_DEV}2" || sudo blkid -o value -s UUID "${HEX_TARGET_DEV}p2")"
    [ "x$hexblade_crypted_uuid" != "x" ]
    local hexblade_crypted_id="$(echo "$hexblade_crypted_uuid" | tr -d '-')"
    [ "x$hexblade_crypted_id" != "x" ]
    local hexblade_root_uuid="$(sudo blkid -o value -s UUID /dev/mapper/LIVECRYPTEDROOT)"
    [ "x$hexblade_root_uuid" != "x" ]
    # hexblade_data_uuid="$(sudo blkid -o value -s UUID /dev/mapper/LIVELVM-LIVEDATA)"

    ../../lib/crypt/crypt.sh initramfs_cryptparts_append iso "/dev/disks/by-uuid/$hexblade_crypted_uuid" LIVECRYPTEDDATA
    ../../lib/util/boot.sh initramfs
    ../../lib/iso/iso.sh compress
   
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
        linux /casper/vmlinuz boot=casper nopersistent verbose nosplash ---
        initrd /casper/initrd
    }
    " > isolinux/grub.cfg
    grub-mkstandalone \
        --format=x86_64-efi \
        --output=isolinux/bootx64.efi \
        --locales="" \
        --fonts="" \
        "boot/grub/grub.cfg=isolinux/grub.cfg"
    cp isolinux/bootx64.efi /mnt/hexblade/cryptiso/efi/efi/boot/
    find . -type f -print0 | xargs -0 md5sum | grep -v -e 'md5sum.txt' -e 'bios.img' -e 'efiboot.img' | tee md5sum.txt
   cd -
}



.gdbh jx    habmlzius3gcsyeihf4v32n-ki1ç0o=

function cmd_sparse_create() {
    local hexblade_size="${1?'hexblade_size, like 8196M'}"
    ../../lib/util/crypt.sh key_check iso
    mkdir -p /mnt/hexblade/live-crypted 
    dd if=/dev/zero of=/mnt/hexblade/live-crypted/block bs=1 count=0 "seek=$hexblade_size" 
    ../../lib/util/gpt.sh wipe "/mnt/hexblade/live-crypted/block"
    ../../lib/util/gpt.sh part_add "/mnt/hexblade/live-crypted/block" 1 0 +512M EF00 'EFI system partition' 
    ../../lib/util/gpt.sh part_add "/mnt/hexblade/live-crypted/block" 2 0 +6G 8300 'PARTCRYPTROOT'
    ../../lib/util/gpt.sh part_add "/mnt/hexblade/live-crypted/block" 3 0 0 8300 'PARTCRYPTDATA'
    du -hs /mnt/hexblade/live-crypted/block
    du -hs --apparent-size /mnt/hexblade/live-crypted/block
    local hex_loop_dev="$(losetup --list --raw --output NAME,BACK-FILE --noheadings | grep "/mnt/hexblade/live-crypted/block$" | cut -d" " -f1)"
    [ "x$hex_loop_dev" != "x" ] || hex_loop_dev=$(losetup -P -f --show /mnt/hexblade/live-crypted/block)
    ../../lib/util/efi.sh format "${hex_loop_dev}p1"
    
    ../../lib/util/crypt.sh format "${hex_loop_dev}p2" iso 1
    ../../lib/util/crypt.sh pass_add "${hex_loop_dev}p2" iso 0
    ../../lib/util/crypt.sh open "${hex_loop_dev}p2" LIVECRYPTEDROOT iso
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDROOT LIVECRYPTEDROOT
    ../../lib/util/crypt.sh close LIVECRYPTEDROOT iso
    
    ../../lib/util/crypt.sh format "${hex_loop_dev}p3" iso 1
    ../../lib/util/crypt.sh pass_add "${hex_loop_dev}p3" iso 0
    ../../lib/util/crypt.sh open "${hex_loop_dev}p3" LIVECRYPTEDDATA iso
    ../../lib/util/mkfs.sh ext4 /dev/mapper/LIVECRYPTEDDATA LIVECRYPTEDDATA
    ../../lib/util/crypt.sh close LIVECRYPTEDDATA iso
 
    losetup -d "$hex_loop_dev"

    du -hs /mnt/hexblade/live-crypted/block
    du -hs --apparent-size /mnt/hexblade/live-crypted/block
     
}

function cmd_sparse_to_vmdk() {
    qemu-img convert -p -f raw -O vmdk /mnt/hexblade/live-crypted/block /mnt/hexblade/live-crypted/block.vmdk
}

function cmd_from_iso() {
    [ -f /mnt/hexblade/live-crypted/block ]
    
    cmd_deiso /mnt/hexblade/iso/hexblade.iso
    cmd_sparse_mount
    cmd_rsync
    
    export HEX_TARGET_DEV="$(losetup --list --raw --output NAME,BACK-FILE --noheadings | grep "/mnt/hexblade/live-crypted/block$" | cut -d" " -f1)"

    cmd_grub
    cmd_sparse_umount
    cmd_sparse_to_vmdk

    du -hs /mnt/hexblade/live-crypted/block
    du -hs --apparent-size /mnt/hexblade/live-crypted/block
    
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"