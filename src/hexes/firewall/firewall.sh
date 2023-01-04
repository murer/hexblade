#!/bin/bash -xe

function cmd_software() {
  apt install -y iptables-persistent
}

function cmd_install() {
  cmd_software
  cmd_apply_deny
  cmd_save
}

function cmd_apply_allow() {
  cat src/allow_all/rules.v4 | iptables-restore
  cat src/allow_all/rules.v6 | ip6tables-restore
}

function cmd_apply_deny() {
  cat src/deny_all/rules.v4 | iptables-restore
  cat src/deny_all/rules.v6 | ip6tables-restore
}

function cmd_install_deny() {
  cmd_software
  cp -v src/deny_all/* /etc/iptables
}

function cmd_port4_open() {
  local hexblade_port_open="${1?'port to open'}"
  iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport "$hexblade_port_open" -m state --state NEW,ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -p tcp -d 0.0.0.0/0 --sport "$hexblade_port_open" -m state --state ESTABLISHED -j ACCEPT
}

function cmd_ip_drop() {
  local hexblade_ip_block="${1?'ip to block'}"
  iptables -A OUTPUT -d "$hexblade_ip_block" -j DROP
  iptables -A INPUT -d "$hexblade_ip_block" -j DROP
}

function cmd_ip_reject() {
  local hexblade_ip_block="${1?'ip to block'}"
  iptables -A OUTPUT -d "$hexblade_ip_block" -j REJECT
  iptables -A INPUT -d "$hexblade_ip_block" -j REJECT
}

function cmd_apply4() {
  iptables -F
  iptables -t nat -F
  iptables -t mangle -F

  iptables -X
  iptables -t nat -X
  iptables -t mangle -X

  # Set default chain policies
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT ACCEPT

  # Accept on localhost
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Accept some ports
  #cmd_port_open 22

  # Allow established sessions to receive traffic
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
}

function cmd_save() {
  netfilter-persistent save
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
