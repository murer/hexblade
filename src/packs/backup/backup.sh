#!/bin/bash -xe

_hex_backup_server="pyrata@s.murerz.com"

cmd_push() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"
    cd /mnt/hexblade/basesys
    cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
