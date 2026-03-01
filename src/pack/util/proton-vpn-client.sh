#!/bin/bash -xe

function cmd_install() {
    mkdir -p /etc/apt/hardkeys
    wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | gpg --dearmor > /etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg] https://repo.protonvpn.com/debian stable main" > /etc/apt/sources.list.d/proton-vpn.list
    apt update
    apt -y install proton-vpn-gnome-desktop
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

