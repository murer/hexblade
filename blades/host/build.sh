#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_deps() {
    apt install -y pulseaudio-esound-compat
    ../../packages/standard/install-standard.sh
    ../../packages/virtualbox/install-virtualbox.sh
}

cmd_config() {
    [[ -f /etc/pulse/default.pa.original ]] || cp -v /etc/pulse/default.pa /etc/pulse/default.pa.original
    cp -Rv etc/* /etc
}

cmd_install() {
    cmd_deps
    cmd_config
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
