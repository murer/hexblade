#!/bin/bash -xe

cmd_bak_tar_create() {
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

cmd_bak_tar_restore() {
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
    local _hex_bak_name="${1?'_hex_bak_name is required'}"
    sudo mkdir -p "/mnt/hexblade/bak/$_hex_bak_name"
    sudo rsync -a --delete -x --info=progress2 /mnt/hexblade/basesys/ "/mnt/hexblade/bak/$_hex_bak_name/"
}

function cmd_bak_rsync_restore() {
    local _hex_bak_name="${1?'_hex_bak_name is required'}"
    sudo mkdir -p /mnt/hexblade/basesys/
    sudo rsync -a --delete -x --info=progress2 "/mnt/hexblade/bak/$_hex_bak_name/" /mnt/hexblade/basesys/
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
