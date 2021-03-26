#!/bin/bash -xe

cmd_xterm() {
    apt -y install xterm
}

cmd_mousepad() {
    apt -y install mousepad
}

cmd_xfce4-screenshooter() {
    apt -y install xfce4-screenshooter
}

cmd_pcmanfm() {
    apt -y install pcmanfm
}

cmd_firefox() {
    apt -y install firefox
}

cmd_thunar() {
    apt -y install thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin 
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
