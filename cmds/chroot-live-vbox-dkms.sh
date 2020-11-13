#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

arch-chroot /mnt/hexblade/installer apt install -y virtualbox-guest-dkms

