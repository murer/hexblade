#!/bin/bash -xe

function cmd_dump() {
    local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
    cryptsetup luksDump "$hexblade_crypt_dev"
}

function cmd_pass_add_from_key() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_key="${2?'keyname, like: /etc/lukskeys/master.key'}"
  local hexblade_crypt_slot="${3?'slot, from 0 to 7'}"
  cryptsetup luksAddKey --key-file "$hexblade_crypt_key" --key-slot "$hexblade_crypt_slot" "$hexblade_crypt_dev"
}

function cmd_pass_add() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_slot="${2?'slot, from 0 to 7'}"
  cryptsetup luksAddKey --key-slot "$hexblade_crypt_slot" "$hexblade_crypt_dev"
}

function cmd_drop_slot() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_slot="${2?'slot, from 0 to 7'}"
  cryptsetup -v luksKillSlot "$hexblade_crypt_dev" "$hexblade_crypt_slot"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
