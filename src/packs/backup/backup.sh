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
    _hex_backup_from_version="${3?'version from is required, use 0 (zero) to create a new one'}"

    [[ -f "$HOME/.ssh/id_rsa" ]]

    if [[ "x$_hex_backup_from_version" == "x0" ]]; then
        if ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"; then
            echo "backup already exists" 1>&2
            false
        fi
    fi
    if ssh "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"; then
        echo "version already exists" 1>&2
        false
    fi
    ssh "$_hex_backup_server" mkdir -p "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"
    
    cd /mnt/hexblade
    sudo rm -rf "rbak/$_hex_backup_to_version"
    sudo mkdir -p "rbak/$_hex_backup_to_version"

    if [[ "x$_hex_backup_from_version" != "x0" ]]; then
        scp "$_hex_backup_server:hexblade/backup/$_hex_backup_name/$_hex_backup_from_version/cursor.sng" "rbak/$_hex_backup_to_version/cursor.sng"
    fi

    _hex_size="$(sudo du -bs basesys | cut -f1)"
    sudo tar cpgf "rbak/$_hex_backup_to_version/cursor.sng" - --one-file-system basesys | \
        pv -s "$_hex_size" | gzip | \
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        ssh "$_hex_backup_server" bash -c "cat > hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg.tmp"
    
    ssh "$_hex_backup_server" mv -v "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg.tmp" "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg"

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
