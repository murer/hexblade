#!/bin/bash -xe

set -o pipefail

export GNUPGHOME=/mnt/hexblade/gnupg

function cmd_prepare() {
    if [[ ! -d /mnt/hexblade/gnupg ]]; then
        [[ -f "$HOME/.ssh/pyrata.gpg.public.key" ]]
        [[ -f "$HOME/.ssh/pyrata.gpg.private.key" ]]
        mkdir -p /mnt/hexblade/gnupg
        chmod 600 /mnt/hexblade/gnupg
        gpg --homedir /mnt/hexblade/gnupg --import "$HOME/.ssh/pyrata.gpg.public.key"
        gpg --homedir /mnt/hexblade/gnupg --import "$HOME/.ssh/pyrata.gpg.private.key"
    fi
}

function cmd_gpg() {
    [[ -d /mnt/hexblade/gnupg ]]
    gpg --homedir /mnt/hexblade/gnupg "$@"
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
