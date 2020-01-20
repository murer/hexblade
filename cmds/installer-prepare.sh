#!/bin/bash -xe

apt-get -y update
apt-get -y install \
  software-properties-common

apt-add-repository universe

apt-get install -y \
  gdisk fdisk gpart \
  cryptsetup \
  debootstrap \
  arch-install-scripts \
  vim curl wget
