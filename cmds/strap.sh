#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

set +x
source target/config/params.txt || true
set -x

tmp_strap_mirror=""
[[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://"$hexblade_apt_mirror".archive.ubuntu.com/ubuntu/"

debootstrap bionic /mnt/hexblade/installer "$tmp_strap_mirror"

#debootstrap bionic /mnt/hexblade/installer

# debootstrap \
#     --arch=amd64 \
#     --variant=minbase \
#     bionic \
#     $HOME/live-ubuntu-from-scratch/chroot \
#     http://us.archive.ubuntu.com/ubuntu/
