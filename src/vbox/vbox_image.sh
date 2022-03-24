#!/bin/bash -xe

function cmd_hex_install() {
    ./vbox.sh vm_ssh_copy_id hex_vbox_base ubuntu
    ./vbox.sh vm_rsync hex_vbox_base ubuntu ../../src/ localhost:/tmp/hexvbox/
    ./vbox.sh vm_ssh hex_vbox_base ubuntu \
        HEX_TARGET_USER=hex HEX_TARGET_PASS=hex HEX_TARGET_DEV=/dev/sda \
        sudo -E /tmp/hexvbox/recipe/util/min_mbr.sh from_scratch
    ./vbox.sh vm_ssh hex_vbox_base ubuntu sync
    sleep 2
}

function cmd_create_base() {
    local hex_vm_iso="${1?'vm_iso'}"
    local hex_vm_disk="${2?'vm_disk'}"
    ./vbox.sh vm_create_from_iso "$hex_vm_iso" hex_vbox_base 5050
    ./vbox.sh vm_start hex_vbox_base
    cmd_hex_install
    ./vbox.sh vm_poweroff hex_vbox_base
    cp "/mnt/hexblade/vbox/$hex_vm_disk/disk1.vmdk" "$hex_vm_disk"
    ./vbox.sh vm_delete hex_vbox_base
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"