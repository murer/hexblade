#!/bin/bash -e

function cmd_efi() {
    local target_dev="${1?'device to be formatted'}"
    mkfs.fat -n ESP -F32 "$target_dev"  
}

function cmd_ext4() {
    local target_dev="${1?'device to be formatted'}"
    local target_label="${2?'label'}"
    yes | mkfs.ext4 -L "$target_label" "$target_dev"  
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"