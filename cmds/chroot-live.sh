#!/bin/bash -xe

# https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/hexblade/installer apt install -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    upower \
    dkms \
    virtualbox-guest-utils

