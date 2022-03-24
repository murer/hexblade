#!/bin/bash -xe

function cmd_vm_delete  () {
    local hex_vm_name="${1?'vm_name'}"
    [[ -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    VBoxManage unregistervm --delete "$hex_vm_name"
    rmdir "/mnt/hexblade/vbox/$hex_vm_name"
}

function cmd_vm_create() {
    local hex_vm_name="${1?'vm_name'}"
    [[ ! -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    mkdir -p /mnt/hexblade/vbox
    VBoxManage createvm --name "$hex_vm_name" \
        --ostype "Ubuntu_641" --register --basefolder "/mnt/hexblade/vbox/$hex_vm_name"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"