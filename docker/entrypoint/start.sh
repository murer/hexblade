#!/bin/bash -xe

arg="${1?'one argument is required, use hexbladestart to start only'}"

if [[ "x$arg" == "xhexbladestart" ]]; then
    xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session
else
    xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session 1>&2 &
    set +x
    for i in $(seq 30); do ncat -zv localhost 5900 && break 1>&2 || sleep 0.1; done
    set -x
    "$@"
fi