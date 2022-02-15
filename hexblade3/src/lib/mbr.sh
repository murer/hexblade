#!/bin/bash -e

cmd_wipe() {
    local target_dev="${1?'device to be wipped'}"
    echo -e "o\nw\n" | fdisk "$target_dev"  
}

cmd_part_add() {
    local target_dev="${1?'device to be wipped'}"
    local part_number="${2?'part_number, like: 1'}"
    local part_start="${3?'part_start, like: 1MB, +1MB or '' (empty) to last partition'}"
    local part_end="${4?'part_end, like: 1MB, +1MB or '' (empty) to max space'}"
    local part_type="${5?'part_type, like: 0x32 for linux or E for extended'}"
    local part_name="${6?'part_name, like: DATA'}"
    echo "$part_start,$part_end,$part_type" | sfdisk -a "$target_dev"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"