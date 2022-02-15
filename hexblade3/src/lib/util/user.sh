#!/bin/bash -xe

function cmd_add() {
    local hexblade_username="${1?'user name is required'}"
    if [[ ! -d "/mnt/hexblade/system/home/$hexblade_username" ]]; then
        local hexblade_password="$2"
        if [ "x$hexblade_password" == "x" ]; then
            hexblade_password="$(openssl passwd -6)"
        fi
        arch-chroot /mnt/hexblade/system useradd -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$hexblade_username" -p "$hexblade_password"
    fi
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
