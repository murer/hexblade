#!/bin/bash -xe

function cmd_dump() {
    local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
    cryptsetup luksDump "$hexblade_crypt_dev"
}

function cmd_adduser() {
    [[ "x$UID" == "x0" ]]
    local hexes_username="${1?'username'}"
    useradd -m -G video -s /usr/sbin/nologin "$hexes_username"
    echo "xhost '+SI:localuser:$hexes_username'" > "/etc/xdg/openbox/autostart.d/20-xhost-user-$hexes_username.sh"
    xhost "+SI:localuser:$hexes_username"
}

function cmd_reuser() {
    local hex_user="${1?'username'}"
    shift
    cd -
    sudo -sHu "$hex_user" -g "$hex_user" \
        NO_AT_BRIDGE=1 DISPLAY="$DISPLAY" PULSE_SERVER=127.0.0.1:4713 "$@"
}

function cmd_fork() {
    local hex_user="${1?'username'}"
    shift
    cd -
    sudo -sHu "$hex_user" -g "$hex_user" -b \
        NO_AT_BRIDGE=1 DISPLAY="$DISPLAY" PULSE_SERVER=127.0.0.1:4713 "$@"
}

function cmd_install() {
    [[ ! -f /usr/local/bin/reuser.sh ]] || [[ "x$1" == "x-f" ]]
    cp -v reuser.sh /usr/local/bin/reuser.sh
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
