#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/installer apt install -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    locales

arch-chroot /mnt/installer apt install -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork
