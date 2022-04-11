#!/bin/bash -xe

arg="${1?'one argument is required, use hexbladestart to start only'}"

if [[ "x$HEX_REGROUP" == "x" ]]; then
    export HEX_REGROUP="$(id -g)"
fi
if [[ "x$HEX_REUSER" == "x" ]]; then
    export HEX_REUSER="$(id -u)"
fi

if [[ "x$HEX_REUSER" != "x$(id -u)" ]] || [[ "x$HEX_REGROUP" != "x$(id -g)" ]]; then
    sudo groupadd -g "$HEX_REGROUP" thex || true
    sudo useradd -u "$HEX_REUSER" -g "$HEX_REGROUP" -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash thex || true
    sudo usermod -aG "$HEX_REGROUP" "$(getent passwd "$HEX_REUSER" | cut -d: -f1)" || true
    cd "/home/$(getent passwd "$HEX_REUSER" | cut -d: -f1)" || true
    export HOME="$(pwd)"
    sudo -Eu "#$HEX_REUSER" -g "#$HEX_REGROUP" "$0" "$@"
else

    if [[ "x$HEX_DROP_PRIVILEGES" == "xtrue" ]]; then
        sudo gpasswd --delete "$(whoami)" adm
        sudo gpasswd --delete "$(whoami)" cdrom
        sudo gpasswd --delete "$(whoami)" sudo
        sudo gpasswd --delete "$(whoami)" dip
        sudo gpasswd --delete "$(whoami)" plugdev
        sudo gpasswd --delete "$(whoami)" supersudo
    fi

    if [[ "x$arg" == "xhexbladestart" ]]; then
        xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session
    else
        xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session &
        set +x
        for i in $(seq 30); do ncat -zv localhost 5900 && break || sleep 0.1; done
        set -x
        "$@"
    fi


fi


