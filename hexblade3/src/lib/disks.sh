#!/bin/bash -e

cmd_gpt_wipe() {
    local target_dev="${1?'device to be wipped'}"
    sgdisk --zap-all "$target_dev"  
    sgdisk -o "$target_dev"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"