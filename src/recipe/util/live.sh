#!/bin/bash -xe

function cmd_mount() {
    [[ ! -d /mnt/hexblade/system ]]    
    mkdir -p /mnt/hexblade/system
    #mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/system    
}

function cmd_umount() {
    #umount /mnt/hexblade/system
    rm -rf /mnt/hexblade/system
}

function cmd_strap() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh strap br
}

function cmd_base() {
    [[ -d /mnt/hexblade/system ]]
    ../../lib/basesys/basesys.sh hostname hex
    ../../lib/basesys/basesys.sh base
    ../../lib/basesys/basesys.sh kernel
    
    ../../lib/util/user.sh add ubuntu '$6$M36hF7PAQWF8j4zp$ihBCh1dWqYd2xdt9ckqkgHuq9KFJICN5Op3nLjmJAAZy49xcqKshuoNJhmDIpD.fJPsI720e8DjU4KsooLFJ1.' # passwd: ubuntu
    #../../lib/util/user.sh add ubuntu '*'
    
    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/tools.sh install
    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/ssh.sh install_server
    #../../lib/util/installer.sh uchr ubuntu /installer/hexblade/hexes/ssh/ssh.sh mykey

    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/virtualbox.sh guest_text
    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/virtualbox.sh guest_dir
}

function cmd_packs() {
    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/docker.sh install
}

function cmd_iso() {
    HEXBLADE_LIVE_DISABLE_ADDUSER=true ../../lib/iso/iso.sh install
    ../../lib/iso/iso.sh compress
    ../../lib/iso/iso.sh iso
    ../../lib/iso/iso.sh sha256
}

function cmd_from_scratch() {
    cmd_mount
    cmd_strap
    cmd_base
    cmd_packs
    cmd_iso
    cmd_umount
}

function cmd_mount_iso() {
    local hexblade_iso="${1?'iso file'}"
    [[ ! -d /mnt/hexblade/liveiso ]]
    cmd_mount
    mkdir -p /mnt/hexblade/liveiso
    mount -o loop "$hexblade_iso" /mnt/hexblade/liveiso
    unsquashfs -f -d /mnt/hexblade/system /mnt/hexblade/liveiso/casper/filesystem.squashfs
    umount /mnt/hexblade/liveiso
    rm -rf /mnt/hexblade/liveiso
}

function cmd_from_iso_with_key() {
    local hexblade_iso="${1?'iso file'}"
    cmd_mount_iso "$hexblade_iso"
    ../../lib/util/installer.sh uchr ubuntu /installer/hexblade/hexes/ssh/ssh.sh mykey
    cmd_iso    
    cmd_umount
}

function cmd_from_iso_passwd() {
    local hexblade_iso="${1?'iso file'}"
    cmd_mount_iso "$hexblade_iso"
    ../../lib/util/installer.sh chr passwd ubuntu
    cmd_iso    
    cmd_umount
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"