#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/installer apt-get install -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    locales
