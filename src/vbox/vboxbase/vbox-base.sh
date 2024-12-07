#!/bin/bash -xe


function cmd_create() {
    rm /mnt/hexbase/out.vdi || true

    mkdir -p /mnt/hexbase/files /mnt/hexbase/out
    cp images/blank.vdi /mnt/hexbase/blank.vdi

    umount /mnt/hexbase/files || true
    kpartx -dv /dev/loop5 || true
    losetup -d /dev/loop5 || true
    [ -f /tmp/hexblade-base.vdi ]
    [ ! -f /mnt/hexbase/my_disk_image.raw ] || rm /mnt/hexbase/my_disk_image.raw
    qemu-img convert -f vdi -O raw /tmp/hexblade-base.vdi /mnt/hexbase/my_disk_image.raw
    losetup loop5 /mnt/hexbase/my_disk_image.raw
    kpartx -arv /dev/loop5
    mount -r /dev/mapper/loop5p1 /mnt/hexbase/files

    umount /mnt/hexbase/out || true
    kpartx -dv /dev/loop6 || true
    losetup -d /dev/loop6 || true
    qemu-img convert -f vdi -O raw /mnt/hexbase/blank.vdi /mnt/hexbase/out.raw
    ../../lib/util/mbr.sh wipe /mnt/hexbase/out.raw
    ../../lib/util/mbr.sh part_add /mnt/hexbase/out.raw 1 0 0 0x83
    losetup loop6 /mnt/hexbase/out.raw
    kpartx -av /dev/loop6
    ../../lib/util/mkfs.sh ext4 /dev/mapper/loop6p1 SYS
    mount /dev/mapper/loop6p1 /mnt/hexbase/out

    rsync -a --delete /mnt/hexbase/files/ /mnt/hexbase/out/
    genfstab -U /mnt/hexbase/out/ > /mnt/hexbase/out/etc/fstab
    arch-chroot /mnt/hexbase/out/ grub-install /dev/loop6

    umount /mnt/hexbase/out
    kpartx -dv /dev/loop6
    losetup -d /dev/loop6
 
    umount /mnt/hexbase/files
    kpartx -dv /dev/loop5
    losetup -d /dev/loop5
    
    qemu-img convert -f raw -O vdi /mnt/hexbase/out.raw /mnt/hexbase/out.vdi

    
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
