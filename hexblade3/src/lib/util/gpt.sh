#!/bin/bash -e

function cmd_wipe() {
    local target_dev="${1?'device to be wipped'}"
    sgdisk --zap-all "$target_dev"  
    sgdisk -o "$target_dev"
}

function cmd_part_add() {
    local target_dev="${1?'device'}"
    local part_number="${2?'part_number, like: 1'}"
    local part_start="${3?'part_start, like: 1MB, +1MB or 0 to last partition'}"
    local part_end="${4?'part_end, like: 1MB, +1MB or 0 to max space'}"
    local part_type="${5?'part_type, like: 8300 for linux or EF00 for EFI'}"
    local part_label="${6?'label'}"
    sgdisk -n "$part_number:$part_start:$part_end" -t "$part_number:$part_type" -c "$part_number:$part_label" "$target_dev"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"