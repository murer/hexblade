#!/bin/bash -xe

_hex_backup_server="pyrata@s.murerz.com"

cmd_rcreate() {
    _hex_backup_name="${1?'backup name is required'}"
    if ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"; then
        echo "backup already exists" 2>&1
        false
    fi
    ssh "$_hex_backup_server" mkdir -p "hexblade/backup/$_hex_backup_name"
    echo "$_hex_backup_name" | ssh "$_hex_backup_server" tee "hexblade/backup/$_hex_backup_name/name.txt"
}

cmd_rdelete_force() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" rm -rvf "hexblade/backup/$_hex_backup_name"
}

# cmd_rlist() {

# }

cmd_rpush() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"
    cd /mnt/hexblade/basesys
    cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
