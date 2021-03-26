#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_pulse() {
    echo 'export PULSE_SERVER="10.0.2.2:4713"' > /etc/profile.d/pulseredirect.sh
}

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
    ../../openbox/openbox.sh install
    ../../openbox/openbox.sh lockscreen disable
    ../../virtualbox/virtualbox.sh guest
    cmd_pulse
}

cmd_gui() {
    cmd_nogui
    ../../lxdm/lxdm.sh install
    ../../lxdm/lxdm.sh autologin "$SUDO_USER"
    ../../lxdm/lxdm.sh tcplisten disable
}


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
