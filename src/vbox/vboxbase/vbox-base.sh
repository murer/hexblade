#!/bin/bash -xe


function cmd_create() {
    [ ! -f /tmp/hexblade-base.vdi ]
    mkdir -p /mnt/hexbase
    qemu-img convert -f vdi -O raw /tmp/hexblade-base.vdi target/my_disk_image.raw
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
