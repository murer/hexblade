#!/bin/bash -xe

arg="${1?'one argument is required, use hexbladestart to start only'}"

if [[ "x$arg" != "xhexbladestart" ]]; then
    (printf "'%s' " "$@" && echo ' &') | sudo tee /etc/xdg/openbox/autostart.d/99-dockercmd.sh
    sudo chmod 644 /etc/xdg/openbox/autostart.d/99-dockercmd.sh
fi

xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session
