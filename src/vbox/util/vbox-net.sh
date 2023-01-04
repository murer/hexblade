#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function cmd_vm_ssh_copy_id() {
    local hex_vm_name="${1?'vm_name'}"
    local hex_vm_user="${2?'vm_user'}"
    local hex_ssh_port="$(VBoxManage showvminfo "$hex_vm_name" --machinereadable | grep 'guestssh,tcp' | cut -d',' -f4)"
    [[ "x$hex_ssh_port" != "x" ]]
    ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -p "$hex_ssh_port" "$hex_vm_user@localhost"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"