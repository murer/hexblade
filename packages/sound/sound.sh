#!/bin/bash -xe

cmd_pavucontrol() {
    apt install -y pavucontrol --no-install-recommends
}

cmd_install() {
    apt install -y pavucontrol pulseaudio
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"