#!/bin/bash -xe

arg="${1?'one argument is required, use hexbladestart to start only'}"

if [[ "x$arg" == "xhexbladestart" ]]; then
    xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session
else
    xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session &
    for i in 1 2 3 4 5; do ncat -zv localhost 5900 && break || sleep 0.1; done
    "$@"
fi

