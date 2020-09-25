#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

apt $HEXBLADE_APT_ARGS -y update
apt $HEXBLADE_APT_ARGS -y install \
  software-properties-common

apt-add-repository universe

apt $HEXBLADE_APT_ARGS install -y \
  gdisk fdisk gpart \
  cryptsetup \
  debootstrap debconf-utils \
  arch-install-scripts \
  vim curl wget \
  binutils \
  squashfs-tools \
  xorriso \
  grub-pc-bin \
  grub-efi-amd64-bin \
  mtools \
  squashfs-tools \
  net-tools \
  nmap
