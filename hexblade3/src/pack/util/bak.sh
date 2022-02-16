#!/bin/bash -xe

function cmd_ssh() {
    ssh -o ConnectTimeout=5 -o ConnectionAttempts=1000 pyrata@s.murerz.com "$@"
}

function cmd_create() {
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
        gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        cmd_ssh bash -xec "cat > hexblade/bak/$hex_bak_target.tgz.gpg"
    cd -

    sudo umount "/mnt/hexblade/bak/$hex_bak_target"
    sudo rmdir "/mnt/hexblade/bak/$hex_bak_target"

}

function cmd_restore() {
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

    cmd_ssh cat "hexblade/bak/$hex_bak_target.tgz.gpg" | \
        pv -s "$_hex_size" | \
        gpg --batch -d --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
        gunzip | sudo tar xpf - 
    cd -

    sudo umount "/mnt/hexblade/bak/$hex_bak_target"
    sudo rmdir "/mnt/hexblade/bak/$hex_bak_target"
}

# function cmd_rsync_create() {
#     local _hex_bak_version="${1?'_hex_bak_version is required'}"
#     sudo mkdir -p "/mnt/hexblade/bak/$_hex_bak_version"
#     sudo rsync -a --delete -x --info=progress2 /mnt/hexblade/basesys/ "/mnt/hexblade/bak/$_hex_bak_version/"
# }

# function cmd_rsync_restore() {
#     local _hex_bak_version="${1?'_hex_bak_version is required'}"
#     sudo mkdir -p /mnt/hexblade/basesys/
#     sudo rsync -a --delete -x --info=progress2 "/mnt/hexblade/bak/$_hex_bak_version/" /mnt/hexblade/basesys/
# }

# function cmd_remote_create() {
#     local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
#     local _hex_bak_name="${2?'_hex_bak_name is required'}"
#     local _hex_bak_version="${3?'_hex_bak_version is required'}"
#     if cmd_ssh "$_hex_bak_server" ls "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"; then
#         echo "Backup already exists: hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg" 1>&2
#         false
#     fi
#     local _hex_size="$(sudo du -bs /mnt/hexblade/basesys | cut -f1)"
#     cmd_ssh "$_hex_bak_server" mkdir -p "hexblade/bak/$_hex_bak_name/$_hex_bak_version"
#     cd /mnt/hexblade/basesys
#     sudo tar cpf - . | pv -s "$_hex_size" | gzip | \
#         gpg --batch -c --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
#         cmd_ssh "$_hex_bak_server" bash -xec "cat > hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"
#     cd -
# }

# function cmd_remote_restore() {
#     local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
#     local _hex_bak_name="${2?'_hex_bak_name is required'}"
#     local _hex_bak_version="${3?'_hex_bak_version is required'}"
#     local _hex_size="$(cmd_ssh "$_hex_bak_server" du -bs "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg" | cut -f1)"
#     cd /mnt/hexblade/basesys
#     cmd_ssh "$_hex_bak_server" cat "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg" | \
#         pv -s "$_hex_size" | \
#         gpg --batch -d --compress-algo none --passphrase-file "$HOME/.ssh/id_rsa" -o - - | \
#         gunzip | sudo tar xpf -
#     cd -
# }

# function cmd_remote_delete_backup() {
#     local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
#     local _hex_bak_name="${2?'_hex_bak_name is required'}"
#     cmd_ssh "$_hex_bak_server" rm -rf "hexblade/bak/$_hex_bak_name"
# }

# function cmd_remote_delete_version() {
#     local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
#     local _hex_bak_name="${2?'_hex_bak_name is required'}"
#     local _hex_bak_version="${3?'_hex_bak_version is required'}"
#     cmd_ssh "$_hex_bak_server" rm -v "hexblade/bak/$_hex_bak_name/$_hex_bak_version.tgz.gpg"
# }

# function cmd_remote_ls() {
#     local _hex_bak_server="${1?'_hex_bak_server is required, like user@host'}"
#     cmd_ssh "$_hex_bak_server" find "hexblade/bak" -name "*.tgz.gpg"
# }

# function cmd_part_create() {
#     #sgdisk --backup=<file> <device>
#     #sgdisk --load-backup=<file> <device>
#     #gdisk -l <device>
#     true
# }


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
