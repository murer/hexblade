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

    cp images/blank.vdi /mnt/hexbase/hexblade.vdi
    # VBoxManage closemedium disk /mnt/hexbase/hexblade.vdi --delete || true
    # VBoxManage createhd --filename  /mnt/hexbase/hexblade.vdi --size 262144 --format VDI


#     VBoxManage snapshot hex_one restore hexblade
# VBoxManage snapshot personal2 restore hexblade

# #VBoxManage storageattach personal2 --storagectl "SATA" --port 3 --device 0 --medium none || true
# VBoxManage closemedium disk hex_one/hex.vdi --delete || true
# [ ! -f hex_one/hex.vdi ]

# #VBoxManage storageattach personal2 --storagectl "SATA" --port 2 --device 0 --medium none || true
# VBoxManage closemedium disk tmp/hex-base.vdi --delete || true
# [ ! -f tmp/hex-base.vdi ]

# #VBoxManage clonehd ./hex_base_v1/hex_base_v1-disk1.vdi tmp/hex-base.vdi --format VDI
# #VBoxManage storageattach personal2 --storagectl "SATA" --port 2 --device 0 --type hdd --medium ./hex_base_v1/hex_base_v1-disk1.vdi

# [ ! -f tmp/hexblade.raw ] || rm tmp/hexblade.raw

# qemu-img convert -f vdi -O raw ./hex_base_v1/hex_base_v1-disk1.vdi tmp/hexblade.raw
# du -hs tmp/*

}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
