#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function cmd_static() {
    local hex_ip="${1?'ip address, like: 192.168.56.123/24'}"
    local hex_gateway="${2?'ip address, like: 192.168.56.1'}"
    nmcli con mod 'Wired connection 1' \
        ipv6.method "disabled" \
        ipv4.method "manual" \
        ipv4.addresses "$hex_ip" \
        ipv4.gateway "$hex_gateway" \
        ipv4.dns "8.8.8.8"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
