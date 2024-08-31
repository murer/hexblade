#!/bin/bash -xe


function cmd_hotspot_create() {
  local _wifi_interface="${1?'_wifi_interface, get from ifconfig or ip a, sample: wlp0s20f3'}"
  nmcli con add type wifi \
    ifname "$_wifi_interface" \
    con-name pyrata3 \
    autoconnect no \
    ssid pyrata3

  nmcli con modify pyrata3 802-11-wireless.mode ap
  nmcli con modify pyrata3 802-11-wireless.band bg
  nmcli con modify pyrata3 ipv6.method disabled
  nmcli con modify pyrata3 ipv4.method shared
  nmcli con modify pyrata3 wifi-sec.key-mgmt wpa-psk
  nmcli con modify pyrata3 wifi-sec.psk "12345678"
}

function cmd_hotspot_up() {
  nmcli con up pyrata3
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"