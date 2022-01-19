#!/bin/bash -xe

_hex_backup_server="pyrata@s.murerz.com"

cmd_create() {
    _hex_backup_version="${1?'backup version is required: v00.00.01'}"
    cd /mnt/hexblade
    sudo mkdir -p backup/v00.00.01
    sudo tar czpgf \
        backup/v00.00.01/cursor.sng \
        backup/v00.00.01/data.tar.gz \
        basesys
    cd -
}

cmd_rcreate() {
    _hex_backup_name="${1?'backup name is required'}"
    _hex_backup_to_version="${2?'version to create is required'}"

    if ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"; then
        echo "backup already exists" 2>&1
        false
    fi
    ssh "$_hex_backup_server" mkdir -p "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"
    echo "$_hex_backup_name" | ssh "$_hex_backup_server" tee "hexblade/backup/$_hex_backup_name/name.txt"

    cd /mnt/hexblade
    sudo rm -rf "rbak/$_hex_backup_to_version"
    sudo mkdir -p "rbak/$_hex_backup_to_version"

    _hex_size="$(sudo du -bs basesys | cut -f1)"
    sudo tar cpgf "rbak/$_hex_backup_to_version/cursor.sng" - --one-file-system basesys | \
        pv -s "$_hex_size" | gzip | \
        ssh "$_hex_backup_server" bash -c "cat > hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/cursor.sng"

    scp "rbak/$_hex_backup_to_version/cursor.sng" "$_hex_backup_server:hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/cursor.sng"
}

cmd_rdelete_force() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" rm -rvf "hexblade/backup/$_hex_backup_name"
}

cmd_rlist() {
    ssh "$_hex_backup_server" ls -lrt "hexblade/backup"
}

cmd_rtags() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" find "hexblade/backup/$_hex_backup_name" -type f
}

cmd_rpush() {
    _hex_backup_name="${1?'backup name is required'}"
    ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"
    cd /mnt/hexblade/basesys
    cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
