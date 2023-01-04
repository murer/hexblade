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
    sudo iptables -A INPUT -i vboxnet0 -s 192.168.56.0/24 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A OUTPUT -o vboxnet0 -d 192.168.56.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT

    # sudo iptables -N VBOXNET0
    # sudo iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    # sudo iptables -I FORWARD  -m state --state RELATED,ESTABLISHED -j ACCEPT
    # sudo iptables -t nat -I POSTROUTING -o wlp0s20f3 -j MASQUERADE
    # sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    # sudo iptables -A VBOXNET0 -j RETURN
    
    # sudo iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    # sudo iptables -I FORWARD  -m state --state RELATED,ESTABLISHED -j ACCEPT

    # sudo iptables -A PREROUTING -m addrtype --dst-type LOCAL -j ACCEPT
    # sudo iptables -A OUTPUT ! -d 192.168.56.0/24 -m addrtype --dst-type LOCAL -j ACCEPT
    # sudo iptables -A POSTROUTING -s 192.168.56.0/24 ! -o vboxnet0 -j MASQUERADE
    # sudo iptables -A DOCKER -i vboxnet0 -j RETURN
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
