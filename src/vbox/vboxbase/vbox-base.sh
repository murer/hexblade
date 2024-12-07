#!/bin/bash -xe


function cmd_create() {
    umount /mnt/hexbase/files || true
    kpartx -dv /dev/loop5 || true
    losetup -d /dev/loop5 || true
    [ -f /tmp/hexblade-base.vdi ]
    mkdir -p /mnt/hexbase/files
    # [ ! -f /mnt/hexbase/my_disk_image.raw ] || rm /mnt/hexbase/my_disk_image.raw
    # qemu-img convert -f vdi -O raw /tmp/hexblade-base.vdi /mnt/hexbase/my_disk_image.raw
    losetup loop5 /mnt/hexbase/my_disk_image.raw
    kpartx -arv /dev/loop5
    mount -r /dev/mapper/loop5p1 /mnt/hexbase/files
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
