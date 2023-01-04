#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function _create() {
    local net_id="${1?'net_num'}"
    local net_range="${2?'net_range'}"
    vboxmanage hostonlyif create
    vboxmanage hostonlyif ipconfig "vboxnet${net_id}" --ip "192.168.$net_range.1" --netmask 255.255.255.0
    #vboxmanage dhcpserver add --interface "vboxnet${net_id}" --server-ip "192.168.$net_range.2" --lowerip "192.168.$net_range.100" --upperip "192.168.$net_range.200" --netmask 255.255.255.0 --enable
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

function cmd_share_internet() {
    file="$(mktemp)"
    _cleanup() {
        rm "$file" || true
    }
    trap _cleanup EXIT
    sudo iptables-save > "$file"
    if grep vboxnet0 "$file"; then
        grep -v vboxnet0 "$file" | sudo iptables-restore
    fi
    sudo iptables -t filter -A FORWARD -s 192.168.56.0/24 ! -d 192.168.56.0/24 -i vboxnet0 -j ACCEPT
    sudo iptables -t filter -A FORWARD ! -s 192.168.56.0/24 -d 192.168.56.0/24 -o vboxnet0 -j ACCEPT
    sudo iptables -t nat -I POSTROUTING -s 192.168.56.0/24 ! -o vboxnet0  -j MASQUERADE
}

function cmd_redirect_port() {
    local hex_port_from="${1?'hex_port_from'}"
    local hex_port_to="${2?'hex_port_to'}"
    sudo iptables -t filter -A FORWARD -i wlp0s20f3 -o vboxnet0 -j ACCEPT
    # sudo iptables -t nat -I POSTROUTING -i wlp0s20f3 ! -o wlp0s20f3 -j MASQUERADE

    # sudo iptables -t nat -I PREROUTING -p tcp --dport "$hex_port_from" -j REDIRECT --to-ports "$hex_port_to"

    # sudo iptables -t nat -A PREROUTING -p tcp --dport "$hex_port_from" -j DNAT --to-destination "192.168.56.50:$hex_port_to"
    # sudo iptables -t nat -A POSTROUTING -p tcp --dport "$hex_port_from" -j SNAT --to-source 10.0.0.253
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
