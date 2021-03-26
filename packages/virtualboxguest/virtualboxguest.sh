#!/bin/bash -xe

cmd_text() {
    apt -y install virtualbox-guest-dkms virtualbox-guest-utils
}

cmd_gui() {
    apt -y install virtualbox-guest-x11
}

cmd_install() {
    cmd_text
    cmd_gui
}



cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"