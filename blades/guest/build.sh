#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_pulse() {
    echo 'export PULSE_SERVER="10.0.2.2:4713"' > /etc/profile.d/pulsereirect.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
