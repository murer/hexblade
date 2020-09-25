#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

apt -y update -o Dpkg::Progress-Fancy="0"
apt -y install -o Dpkg::Progress-Fancy="0" \
  software-properties-common

apt-add-repository universe

apt install -y -o Dpkg::Progress-Fancy="0" \
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
