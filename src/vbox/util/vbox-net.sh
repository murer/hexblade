#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function _create() {
    local net_id="${1?'net_num'}"
    local net_range="${2?'net_range'}"
    vboxmanage hostonlyif create
    vboxmanage hostonlyif ipconfig "vboxnet${net_id}" --ip "192.168.$net_range.1" --netmask 255.255.255.0
    vboxmanage dhcpserver add --interface "vboxnet${net_id}" --server-ip "192.168.$net_range.2" --lowerip "192.168.$net_range.100" --upperip "192.168.$net_range.200" --netmask 255.255.255.0 --enable
}

function cmd_prepare() {
    if vboxmanage list -l hostonlyifs | grep vboxnet0; then
       false
    fi
    _create 0 56
}

function cmd_drop() {
    vboxmanage dhcpserver remove --interface "vboxnet0" || true
    vboxmanage hostonlyif remove vboxnet0 || true
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"