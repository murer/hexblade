#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_pulse() {
    echo 'export PULSE_SERVER="10.0.2.2:4713"' > /etc/profile.d/pulsereirect.sh
}

cmd_nogui() {
    ../../packages/tools/tools.sh install
    ../../packages/graphics/graphics.sh xterm
    ../../packages/lxterminal/lxterminal.sh install
    ../../packages/graphics/graphics.sh mousepad
    ../../packages/graphics/graphics.sh xfce4-screenshooter
    ../../packages/graphics/graphics.sh pcmanfm
    ../../packages/graphics/graphics.sh firefox
    ../../packages/graphics/graphics.sh network-manager-gnome
    ../../packages/sound/sound.sh pavucontrol
    ../../packages/openbox/openbox.sh install
    cmd_pulse
}

cmd_gui() {
    cmd_nogui.
    ../../packages/lxdm/lxdm.sh install
}


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
