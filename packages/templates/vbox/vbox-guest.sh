#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_nogui() {
    ../../tools/tools.sh install
    ../../graphics/graphics.sh xterm
    ../../lxterminal/lxterminal.sh install
    ../../graphics/graphics.sh mousepad
    ../../graphics/graphics.sh xfce4-screenshooter
    ../../graphics/graphics.sh pcmanfm
    ../../graphics/graphics.sh firefox
    ../../chrome/chrome.sh install
    ../../graphics/graphics.sh network-manager-gnome
    ../../sound/sound.sh pavucontrol
    ../../sound/sound.sh pulse_server '10.0.2.2:4713'
    ../../openbox/openbox.sh install
    ../../openbox/openbox.sh lockscreen disable
    ../../virtualbox/virtualbox.sh guest
}

cmd_gui() {
    cmd_nogui
    ../../lxdm/lxdm.sh install
    ../../lxdm/lxdm.sh autologin "$SUDO_USER"
    ../../lxdm/lxdm.sh tcplisten disable
}


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
