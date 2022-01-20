#!/bin/bash -xe

function cmd_ssh() {
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 "$@"
}

function cmd_bak_tar_create() {
    local _hex_bakfile="${1?'_hex_bakfile is required, you can use - to stdout'}"
    local _hex_size="$(sudo du -bs /mnt/hexblade/basesys | cut -f1)"
    if [[ "x$_hex_bakfile" != "x-" ]]; then
        _hex_bakfile="$(readlink -f "$_hex_bakfile")"
    fi
    cd /mnt/hexblade/basesys
    sudo tar cpf - . | pv -s "$_hex_size" | gzip | \
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        sudo tee "$_hex_bakfile" > /dev/null 
    cd -
}

function cmd_bak_tar_restore() {
    local _hex_bakfile="${1?'_hex_bakfile is required, you can use - to stdin'}"
    local _hex_cat="cat"
    if [[ "x$_hex_bakfile" != "x-" ]]; then
        _hex_bakfile="$(readlink -f "$_hex_bakfile")"
        _hex_cat="pv"
    fi

    cd /mnt/hexblade/basesys
    sudo "$_hex_cat" "$_hex_bakfile" | \
        gpg --batch -d --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        gunzip | sudo tar xpf - 
    cd -
}


function cmd_bak_rsync_create() {
    local _hex_bak_version="${1?'_hex_bak_version is required'}"
    sudo mkdir -p "/mnt/hexblade/bak/$_hex_bak_version"
    sudo rsync -a --delete -x --info=progress2 /mnt/hexblade/basesys/ "/mnt/hexblade/bak/$_hex_bak_version/"
}

function cmd_bak_rsync_restore() {
    local _hex_bak_version="${1?'_hex_bak_version is required'}"
    sudo mkdir -p /mnt/hexblade/basesys/
    sudo rsync -a --delete -x --info=progress2 "/mnt/hexblade/bak/$_hex_bak_version/" /mnt/hexblade/basesys/
}

function cmd_bak_remote_create() {
    local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
    local _hex_bak_name="${2?'_hex_bak_name is required'}"
    local _hex_bak_version="${3?'_hex_bak_version is required'}"
    if cmd_ssh "$_hex_bak_server" ls "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"; then
        echo "Backup already exists: hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg" 1>&2
        false
    fi
    local _hex_size="$(sudo du -bs /mnt/hexblade/basesys | cut -f1)"
    cmd_ssh "$_hex_bak_server" mkdir -p "hexblade/bak/$_hex_bak_name/$_hex_bak_version"
    cd /mnt/hexblade/basesys
    sudo tar cpf - . | pv -s "$_hex_size" | gzip | \
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        cmd_ssh "$_hex_bak_server" bash -xec "cat > hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"
}

function cmd_bak_remote_delete_backup() {
    local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
    local _hex_bak_name="${2?'_hex_bak_name is required'}"
    cmd_ssh "$_hex_bak_server" rm -rf "hexblade/bak/$_hex_bak_name"
}

function cmd_bak_remote_delete_version() {
    local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
    local _hex_bak_name="${2?'_hex_bak_name is required'}"
    local _hex_bak_version="${3?'_hex_bak_version is required'}"
    cmd_ssh "$_hex_bak_server" rm -v "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"
}



cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
