#!/bin/bash -xe

function cmd_install() {
    mkdir -p /etc/apt/hardkeys
    wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | gpg --dearmor > /etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg] https://repo.protonvpn.com/debian stable main" > /etc/apt/sources.list.d/proton-vpn.list
    apt update
    apt -y install proton-vpn-gtk-app #proton-vpn-gnome-desktop proton-vpn-cli
}

function cmd_config() {
    protonvpn config set ipv6 off
    protonvpn config set kill-switch standard
    [ "x$USER" == "xroot" ] || sudo usermod -aG netdev "$USER"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

