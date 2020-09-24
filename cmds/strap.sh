#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

debootstrap bionic /mnt/installer

# debootstrap \
#     --arch=amd64 \
#     --variant=minbase \
#     bionic \
#     $HOME/live-ubuntu-from-scratch/chroot \
#     http://us.archive.ubuntu.com/ubuntu/
