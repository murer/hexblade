#!/bin/bash -e

function cmd_wipe() {
    local target_dev="${1?'device to be wipped'}"
    #echo -e "o\nw\n" | fdisk "$target_dev"  
    echo "label: dos" | sudo sfdisk "$target_dev"
}

function cmd_part_add() {
    local target_dev="${1?'device'}"
    local part_number="${2?'part_number, like: 1'}"
    local part_start="${3?'part_start, like: 1MB, +1MB or 0 to last partition'}"
    local part_end="${4?'part_end, like: 1MB, +1MB or 0 to max space'}"
    local part_type="${5?'part_type, like: 0x32 for linux, E for extended, S for swap or 0x8E for lvm'}"
    if [[ "x$part_start" == "x0" ]]; then part_start=""; else part_start="start=$part_start, "; fi
    if [[ "x$part_end" == "x0" ]]; then part_end=""; else part_end="size=$part_end, "; fi
    echo "$target_dev$part_number : $part_start $part_end type=$part_type" | tee | sfdisk -a "$target_dev"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"