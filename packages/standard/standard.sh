#!/bin/bash -xe


cmd_install() {
    ../tools/tools.sh install

    ../graphics/graphics.sh xterm
    
    ../lxterminal/lxterminal.sh install
    
    ../graphics/graphics.sh mousepad
    ../graphics/graphics.sh xfce4-screenshooter
    ../graphics/graphics.sh pcmanfm
    ../graphics/graphics.sh firefox

    ../graphics/graphics.sh network-manager-gnome

    ../pulseaudio/install-pulseaudio.sh
    ../networkmanager/install-networkmanager.sh
    ../openbox/install-openbox.sh
    ../lxdm/install-lxdm.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"