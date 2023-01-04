#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function cmd_static() {
    nmcli con mod 'Wired connection 1' \
        ipv4.method "manual" \
        ipv4.addresses "192.168.56.50/24" \
        ipv4.gateway "192.168.56.1" \
        ipv4.dns "8.8.8.8"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
