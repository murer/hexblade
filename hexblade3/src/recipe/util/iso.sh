#!/bin/bash -xe

function cmd_config_check() {
    export HEX_TARGET_USER="${HEX_TARGET_USER:-hex}"
    if [[ "x$HEX_TARGET_PASS" == "x" ]]; then
        export HEX_TARGET_PASS='$6$AwVQEp9TchgwKwW4$dvsFsq2sY/oQQFtj81sZatFCggBkHnpSVWvFTrnkD/eWEVnBQDdq96G5BGLbyI6iuC6O.BqZrEoxhPRosbMEt/'
    fi
}

function cmd_mount() {
    [[ ! -d /mnt/hexblade/system ]]    
    mkdir -p /mnt/hexblade/system
    mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/system    
}

function cmd_strap() {
    ./min_mbr.sh strap
}

function cmd_base() {
    ./min_mbr.sh base
}

function cmd_from_scratch() {
    cmd_mount
    cmd_strap
    cmd_base
#    ../../lib/util/installer.sh umount
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"