#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cmd_strap() {
    _hex_mirror="${HEXBLADE_UBUNTU_MIRROR_COUNTRY:-br}"
    [[ ! -d /mnt/hexblade/basesys ]]
    mkdir -p /mnt/hexblade/basesys
    debootstrap focal /mnt/hexblade/basesys "http://${_hex_mirror}.archive.ubuntu.com/ubuntu/"
}

cmd_backup() {
    mkdir -p /mnt/hexblade/basebak
    rsync -a --delete -x --info=progress2 /mnt/hexblade/basesys/ /mnt/hexblade/basebak/
}

cmd_restore() {
    mkdir -p /mnt/hexblade/basesys/
    rsync -a --delete -x --info=progress2 /mnt/hexblade/basebak/ /mnt/hexblade/basesys/
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
