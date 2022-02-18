#!/bin/bash -xe

function cmd_xterm() {
    apt -y install --no-install-recommends xterm
}

function cmd_mousepad() {
    apt -y install --no-install-recommends mousepad
}

function cmd_xfce4-screenshooter() {
    apt -y install --no-install-recommends xfce4-screenshooter
}

function cmd_pcmanfm() {
    apt -y install --no-install-recommends pcmanfm
}

function cmd_firefox() {
    apt -y install firefox
}

function cmd_network-manager-gnome() {
    apt -y install --no-install-recommends network-manager-gnome
}

function cmd_thunar() {
    apt -y install --no-install-recommends thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin 
}

function cmd_ubiquity() {
    apt install -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork \
        upower
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"