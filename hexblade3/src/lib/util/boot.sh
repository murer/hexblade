#!/bin/bash -xe

function cmd_initramfs() {
    arch-chroot /mnt/hexblade/system update-initramfs -u -k all
}

function cmd_boot() {
    hexblade_grub_dev="${1?'hexblade_grub_dev is required'}"
    arch-chroot /mnt/hexblade/system update-grub
    arch-chroot /mnt/hexblade/system grub-install "$hexblade_grub_dev"
    cmd_initramfs
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

