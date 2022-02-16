#!/bin/bash -xe

function cmd_key_load() {
    [[ ! -f /mnt/hexblade/bakkey/bak.key ]]
    [[ -f "$HOME/.ssh/id_rsa" ]]
    sudo mkdir /mnt/hexblade/bakkey
    sudo openssl sha256 -binary -out /mnt/hexblade/bakkey/bak.key "$HOME/.ssh/id_rsa"
}

function cmd_ssh() {
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 pyrata@s.murerz.com "$@"
}

function cmd_create() {
    [[ -f /mnt/hexblade/bakkey/bak.key ]]
    local hex_bak_name="${1?'backup namespace'}"
    local hex_bak_tag="${2?'backup tag'}"
    local hex_bak_dev_label="${3?'device label to backup'}"
    ls "/dev/disk/by-label/$hex_bak_dev_label"
    local hex_bak_target="$hex_bak_name/$hex_bak_tag/$hex_bak_dev_label"
    [[ ! -d "/mnt/hexblade/bak/$hex_bak_target" ]]
    
    if cmd_ssh ls "hexblade/bak/$hex_bak_target.tgz.gpg"; then
        echo "Backup already exists: hexblade/bak/$hex_bak_target.tgz.gpg" 1>&2
        false
    fi

    cmd_ssh mkdir -p "hexblade/bak/$hex_bak_name/$hex_bak_tag"

    sudo mkdir -p "/mnt/hexblade/bak/$hex_bak_target"
    sudo mount "/dev/disk/by-label/$hex_bak_dev_label" "/mnt/hexblade/bak/$hex_bak_target"

    cd /mnt/hexblade/bak
    local _hex_size="$(sudo du -bs "/mnt/hexblade/bak/$hex_bak_target" | cut -f1)"
    sudo tar cpf - .  | pv -s "$_hex_size" | gzip | \
        gpg --no-options --batch -c --compress-algo none --passphrase-file /mnt/hexblade/bakkey/bak.key -o - - | \
        cmd_ssh bash -xec "cat > hexblade/bak/$hex_bak_target.tgz.gpg"
    cd -

    sudo umount "/mnt/hexblade/bak/$hex_bak_target"
    sudo rmdir "/mnt/hexblade/bak/$hex_bak_target"

}

function cmd_restore() {
    [[ -f /mnt/hexblade/bakkey/bak.key ]]
    local hex_bak_name="${1?'backup namespace'}"
    local hex_bak_tag="${2?'backup tag'}"
    local hex_bak_dev_label="${3?'device label to backup'}"
    ls "/dev/disk/by-label/$hex_bak_dev_label"
    local hex_bak_target="$hex_bak_name/$hex_bak_tag/$hex_bak_dev_label"
    [[ ! -d "/mnt/hexblade/bak/$hex_bak_target" ]]
    
    if ! cmd_ssh ls "hexblade/bak/$hex_bak_target.tgz.gpg"; then
        echo "Backup do not exist: hexblade/bak/$hex_bak_target.tgz.gpg" 1>&2
        false
    fi

    local _hex_size="$(cmd_ssh du -bs "hexblade/bak/$hex_bak_target.tgz.gpg" | cut -f1)"

    sudo mkdir -p "/mnt/hexblade/bak/$hex_bak_target"
    sudo mount "/dev/disk/by-label/$hex_bak_dev_label" "/mnt/hexblade/bak/$hex_bak_target"

    cd /mnt/hexblade/bak

    sudo find "/mnt/hexblade/bak/$hex_bak_target" -mindepth 1 -delete

    cmd_ssh cat "hexblade/bak/$hex_bak_target.tgz.gpg" | \
        pv -s "$_hex_size" | \
        gpg --no-options --batch -d --compress-algo none --passphrase-file /mnt/hexblade/bakkey/bak.key -o - - | \
        gunzip | sudo tar xpf - 
    cd -

    sudo umount "/mnt/hexblade/bak/$hex_bak_target"
    sudo rmdir "/mnt/hexblade/bak/$hex_bak_target"
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"