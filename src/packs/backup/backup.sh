#!/bin/bash -xe

cmd_backup() {
    local _hex_destfile="${1?'_hex_destfile is required, you can use - to stdout'}"
    local _hex_size="$(sudo du -bs /mnt/hexblade/basesys | cut -f1)"
    cd /mnt/hexblade/basesys
    sudo tar cpf - . | pv -s "$_hex_size" | gzip | \
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o "$_hex_destfile" - 
    cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
