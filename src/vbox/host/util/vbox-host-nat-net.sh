#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function cmd_port_redirect() {
    local hex_vm_name="${1?'hex_vm_name'}"
    local hex_vm_if_id="${2?'hex_vm_if_id, like: 1'}"
    local hex_vm_rule_id="${3?'hex_vm_rule_id, like: r1'}"
    local hex_host_address="${4?'hex_host_address, like: 0.0.0.0 or 127.0.0.1'}"
    local hex_port_from="${5?'hex_port_from'}"
    local hex_port_to="${6?'hex_port_to'}"

    vboxmanage controlvm "$hex_vm_name" "natpf$hex_vm_if_id" delete "$hex_vm_rule_id" || true
    vboxmanage modifyvm "$hex_vm_name" "--natpf$hex_vm_if_id" delete "$hex_vm_rule_id" || true
    vboxmanage modifyvm "$hex_vm_name" "--natpf$hex_vm_if_id" "$hex_vm_rule_id,tcp,$hex_host_address,$hex_port_from,,$hex_port_to" || \
        vboxmanage controlvm "$hex_vm_name" "natpf$hex_vm_if_id" "$hex_vm_rule_id,tcp,$hex_host_address,$hex_port_from,,$hex_port_to" 
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
