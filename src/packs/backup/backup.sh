#!/bin/bash -xe

_hex_backup_server="pyrata@s.murerz.com"

cmd_create() {
    local _hex_backup_version="${1?'backup version is required: v00.00.01'}"
    cd /mnt/hexblade
    sudo mkdir -p backup/v00.00.01
    sudo tar czpgf \
        backup/v00.00.01/cursor.sng \
        backup/v00.00.01/data.tar.gz \
        basesys
    cd -
}

cmd_hash_gen() {
    local _hex_backup_name="${1?'backup name is required'}"
    local _hex_backup_to_version="${2?'version to create is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" bash -xec "\"cd hexblade/backup/$_hex_backup_name/$_hex_backup_to_version; sha256sum -b parent.txt cursor.sng data.tar.gz.gpg > SHA256\""
}

cmd_hash_check() {
    local _hex_backup_name="${1?'backup name is required'}"
    local _hex_backup_to_version="${2?'version to create is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" bash -xec "\"cd hexblade/backup/$_hex_backup_name/$_hex_backup_to_version; sha256sum -c SHA256\""
}

cmd_rcreate() {
    local _hex_backup_name="${1?'backup name is required'}"
    local _hex_backup_to_version="${2?'version to create is required'}"
    local _hex_backup_from_version="${3?'version from is required, use 0 (zero) to create a new one'}"

    [[ -f "$HOME/.ssh/id_rsa" ]]

    if ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"; then
        echo "version already exists" 1>&2
        false
    fi
    if [[ "x$_hex_backup_from_version" == "x0" ]]; then
        if ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"; then
            echo "backup already exists" 1>&2
            false
        fi
    else
        cmd_hash_check "$_hex_backup_name" "$_hex_backup_from_version"
    fi

    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" mkdir -p "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"
    
    cd /mnt/hexblade
    sudo rm -rf "rbak/$_hex_backup_to_version"
    sudo mkdir -p "rbak/$_hex_backup_to_version"

    if [[ "x$_hex_backup_from_version" != "x0" ]]; then
        ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" cat "hexblade/backup/$_hex_backup_name/$_hex_backup_from_version/cursor.sng" | sudo tee "rbak/$_hex_backup_to_version/cursor.sng" > /dev/null
    fi

    echo "$_hex_backup_from_version" | ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" bash -xec "cat > hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/parent.txt"

    _hex_size="$(sudo du -bs basesys | cut -f1)"
    sudo tar cpgf "rbak/$_hex_backup_to_version/cursor.sng" - --one-file-system basesys | \
        pv -s "$_hex_size" | gzip | \
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" bash -xec "cat > hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg.tmp"
    
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" mv -v "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg.tmp" "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/data.tar.gz.gpg"

    pv "rbak/$_hex_backup_to_version/cursor.sng" | ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" bash -xec "cat > hexblade/backup/$_hex_backup_name/$_hex_backup_to_version/cursor.sng"

    cmd_hash_gen "$_hex_backup_name" "$_hex_backup_to_version"
}

cmd_rdelete_ver_force() {
    local _hex_backup_name="${1?'backup name is required'}"
    local _hex_backup_to_version="${2?'version to create is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" rm -rvf "hexblade/backup/$_hex_backup_name/$_hex_backup_to_version"
}

cmd_rdelete_bak_force() {
    local _hex_backup_name="${1?'backup name is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" rm -rvf "hexblade/backup/$_hex_backup_name"
}

cmd_rls_bak() {
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" ls "hexblade/backup" | sort
}

cmd_rls_ver() {
    local _hex_backup_name="${1?'backup name is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" find "hexblade/backup/$_hex_backup_name" -type f -name SHA256 | cut -d'/' -f4
}

cmd_rpush() {
    local _hex_backup_name="${1?'backup name is required'}"
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$_hex_backup_server" ls "hexblade/backup/$_hex_backup_name"
    cd /mnt/hexblade/basesys
    cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
