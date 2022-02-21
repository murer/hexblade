#!/bin/bash -xe

function cmd_pavucontrol() {
    apt install -y pavucontrol --no-install-recommends
}

function cmd_pulseaudio() {
    local packages="pulseaudio"
    if dmesg | grep -i bluetooth | grep -i firmware; then
    	packages="$packages blueman pulseaudio-module-bluetooth"
    fi
    apt install -y pavucontrol $packages
    [[ -f /etc/pulse/default.pa.original ]] || cp -v /etc/pulse/default.pa /etc/pulse/default.pa.original
}

function cmd_restart() {
    if [[ "x$SUDO_USER" != "x" ]]; then
        sudo -Eu "$SUDO_USER" systemctl --user restart pulseaudio.service
        sudo -Eu "$SUDO_USER" systemctl --user restart pulseaudio.socket
    else
        systemctl --user restart pulseaudio.service
        systemctl --user restart pulseaudio.socket
    fi
}

function cmd_tcp() {
    cmd_pulseaudio
    sed -i 's/#load-module module-native-protocol-tcp.*$/load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1/g' /etc/pulse/default.pa
    sed -i 's/^#load-module module-zeroconf-publish.*$/load-module module-zeroconf-publish/g' /etc/pulse/default.pa
    cmd_restart
}

function cmd_pulse_server() {
    local hexblade_pulse_server="${1:-127.0.0.1:4713}"
    echo "export PULSE_SERVER=\"$hexblade_pulse_server\"" > /etc/profile.d/pulseredirect.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
