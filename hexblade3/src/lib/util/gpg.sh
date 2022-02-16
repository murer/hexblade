#!/bin/bash -xe

set -o pipefail

export GNUPGHOME=/mnt/hexblade/gnupg

function cmd_prepare() {
    if [[ ! -d /mnt/hexblade/gnupg ]]; then
        mkdir /mnt/hexblade/gnupg
        [[ -f "$HOME/.ssh/pyrata.gpg.public.key" ]]
        gpg --homedir /mnt/hexblade/gnupg --import "$HOME/.ssh/pyrata.gpg.public.key"
    fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
