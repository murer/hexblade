#!/bin/bash -e

cmd_efi() {
    local target_dev="${1?'device to be wipped'}"
    mkfs.fat -n ESP -F32 "$target_dev"  
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"