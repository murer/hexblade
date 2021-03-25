#!/bin/bash -xe

apt -y update
apt -y install software-properties-common

apt-add-repository universe

apt install -y --no-install-recommends \
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
  nmap \
  ncat \
  git \
  socat
