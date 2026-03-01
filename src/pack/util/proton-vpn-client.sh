#!/bin/bash -xe

function cmd_group() {
  usermod -aG netdev "${1?'uername'}"
}

function cmd_install() {
    mkdir -p /etc/apt/hardkeys
    wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | gpg --dearmor > /etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg
    echo "deb [signed-by=/etc/apt/hardkeys/protonvpn-stable-archive-keyring.gpg] https://repo.protonvpn.com/debian stable main" > /etc/apt/sources.list.d/proton-vpn.list
    apt update
    apt -y install proton-vpn-gtk-app #proton-vpn-gnome-desktop proton-vpn-cli

    if [[ "x$hexblade_user" != "x" ]]; then
        cmd_group "$hexblade_user"
    elif [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
        cmd_group "$SUDO_USER"
    elif [[ "x$UID" != "x0" ]]; then
        cmd_group "$USER"
    fi
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

