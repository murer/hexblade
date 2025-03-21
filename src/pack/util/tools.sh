#!/bin/bash -xe

function cmd_install() {
  apt -y install software-properties-common
  apt-add-repository -y universe
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
    socat \
    crudini \
    htop \
    dnsutils \
    iputils-ping \
    bzip2 \
    qemu-utils \
    pv
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
