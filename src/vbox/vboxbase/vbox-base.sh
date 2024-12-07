#!/bin/bash -xe


function cmd_create() {
    [ -f /tmp/hexblade-base.vdi ]
    mkdir -p /mnt/hexbase
    [ ! -f /mnt/hexbase/my_disk_image.raw ] || rm /mnt/hexbase/my_disk_image.raw
    qemu-img convert -f vdi -O raw /tmp/hexblade-base.vdi /mnt/hexbase/my_disk_image.raw
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
