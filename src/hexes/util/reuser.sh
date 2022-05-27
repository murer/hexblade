#!/bin/bash -xe

function cmd_redir() {
    [[ "x$UID" == "x0" ]]
    local hex_dir="${1?'hex_dir_from'}"

    [[ -d /localdata ]]
    hex_dir="$(realpath "$hex_dir")"
    [[ -d "$hex_dir" ]]
    [[ ! -L "$hex_dir" ]]

    local hex_user="$(stat -c '%U' "$hex_dir")"
    local hex_group="$(stat -c '%G' "$hex_dir")"
    [[ "x$(sudo -u "$hex_user" whoami)" == "x$hex_user" ]] 

    local hex_target="$(echo -n "$hex_dir" | 
        base64 -w0 | tr '/+' '_-' | tr -d '=')"
    [[ ! -d "$hex_target" ]]

    sudo mkdir -p "/localdata/hexes/redir/$hex_user"
    [[ -d "/localdata/hexes/redir/$hex_user" ]]
    [[ ! -d "/localdata/hexes/redir/$hex_user/$hex_target" ]]

    mv "$hex_dir" "/localdata/hexes/redir/$hex_user/$hex_target"
    ln -s "/localdata/hexes/redir/$hex_user/$hex_target" "$hex_dir"
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
        DISPLAY="$DISPLAY" PULSE_SERVER=127.0.0.1:4713 "$@"
}

function cmd_fork() {
    local hex_user="${1?'username'}"
    shift
    cd -
    sudo -sHu "$hex_user" -g "$hex_user" -b \
        DISPLAY="$DISPLAY" PULSE_SERVER=127.0.0.1:4713 "$@"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
