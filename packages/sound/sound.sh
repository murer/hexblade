#!/bin/bash -xe

cmd_pavucontrol() {
    apt install -y pavucontrol --no-install-recommends
}

cmd_pulseaudio() {
    packages="pulseaudio"
    if dmesg | grep -i bluetooth | grep -i firmware; then
    	packages="$packages blueman pulseaudio-module-bluetooth"
    fi
    apt install -y pavucontrol $packages
}

cmd_restart() {
    if [[ "x$SUDO_USER" != "x" ]]; then
        sudo -Eu "$SUDO_USER" systemctl --user restart pulseaudio.service
        sudo -Eu "$SUDO_USER" systemctl --user restart pulseaudio.socket
    else
        systemctl --user restart pulseaudio.service
        systemctl --user restart pulseaudio.socket
    fi
}

cmd_backup() {
    [[ -f /etc/pulse/default.pa.original ]] || cp -v /etc/pulse/default.pa /etc/pulse/default.pa.original
}

cmd_tcp() {
    sed -i 's/#load-module module-native-protocol-tcp.*$/load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1/g' /etc/pulse/default.pa
    sed -i 's/^#load-module module-zeroconf-publish.*$/load-module module-zeroconf-publish/g' /etc/pulse/default.pa
    cmd_restart
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
