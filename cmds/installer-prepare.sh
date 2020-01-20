#!/bin/bash -xe

apt-get -y update
apt-get -y install \
  software-properties-common

apt-add-repository universe

apt-get install -y \
  gdisk fdisk gpart \
  cryptsetup \
  debootstrap debconf-utils \
  arch-install-scripts \
  vim curl wget

sudo dpkg-reconfigure keyboard-configuration
