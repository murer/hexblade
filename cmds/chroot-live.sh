#!/bin/bash -xe

# https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS install -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    upower

arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS install -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork \
