#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/installer apt $hexblade_apt_argsinstall -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    locales

arch-chroot /mnt/installer apt $hexblade_apt_argsinstall -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork \
        upower
