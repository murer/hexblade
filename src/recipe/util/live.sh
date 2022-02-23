#!/bin/bash -xe

function cmd_mount() {
    [[ ! -d /mnt/hexblade/system ]]    
    mkdir -p /mnt/hexblade/system
    mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/system    
}

function cmd_umount() {
    umount /mnt/hexblade/system
    rmdir /mnt/hexblade/system
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
    ../../lib/util/user.sh add ubuntu '$6$mGAOvwh5CP.LymHW$LLJaJCOo8Odj0w9jFXhEWLs90YEuy/EES5nwiIWZkEEnhs5jnzDqd4y96qDk/c9euGzMc8oFWsUkykTTYbk1T.'
    ../../lib/util/installer.sh uchr ubuntu sudo -E /installer/hexblade/pack/util/tools.sh install
    ../../lib/util/installer.sh uchr ubuntu /installer/hexblade/pack/util/ssh.sh install_server
    ../../lib/util/installer.sh uchr ubuntu /installer/hexblade/hexes/ssh/ssh.sh mykey
}

function cmd_iso() {
    ../../lib/iso/iso.sh install
    ../../lib/iso/iso.sh compress
    ../../lib/iso/iso.sh iso
    ../../lib/iso/iso.sh sha256
}

function cmd_from_scratch() {
    cmd_mount
    cmd_strap
    cmd_base
    cmd_iso
    cmd_umount
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"