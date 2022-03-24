#!/bin/bash -xe

function cmd_abc() {
    ./vbox.sh vm_ssh_copy_id hex_vbox_base ubuntu
    ./vbox.sh vm_rsync hex_vbox_base ubuntu ../../src/ localhost:/tmp/hexvbox/
    ./vbox.sh vm_ssh hex_vbox_base ubuntu \
        HEX_TARGET_USER=hex HEX_TARGET_PASS=hex HEX_TARGET_DEV=/dev/sda \
        sudo -E /tmp/hexvbox/recipe/util/min_mbr.sh from_scratch
}

function cmd_create_base() {
    ./vbox.sh vm_create_from_iso /mnt/hexblade/iso/hexblade.iso hex_vbox_base 5050
    ./vbox.sh vm_start hex_vbox_base
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"