#!/bin/bash -xe

cmd_xterm() {
    apt -y install --no-install-recommends xterm
}

cmd_mousepad() {
    apt -y install --no-install-recommends mousepad
}

cmd_xfce4-screenshooter() {
    apt -y install --no-install-recommends xfce4-screenshooter
}

cmd_pcmanfm() {
    apt -y install --no-install-recommends pcmanfm
}

cmd_firefox() {
    apt -y install firefox
}

cmd_network-manager-gnome() {
    apt -y install --no-install-recommends network-manager-gnome
}

cmd_thunar() {
    apt -y install --no-install-recommends thunar thunar-volman thunar-archive-plugin thunar-media-tags-plugin 
}

cmd_ubiquity() {
    apt install -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork \
        upower
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
