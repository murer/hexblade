#!/bin/bash -xe

function _encode {
  (if [ -z "$1" ]; then cat -; else echo -n "$1"; fi) |
    openssl 
}

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

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"