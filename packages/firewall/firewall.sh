#!/bin/bash -xe

cmd_software() {
  apt install -y iptables-persistent
}

cmd_install() {
  cmd_software
  cmd_apply_deny
  cmd_save
}

cmd_apply_allow() {
  cat src/allow_all/rules.v4 | sudo iptables-restore
  cat src/allow_all/rules.v6 | sudo ip6tables-restore
}

cmd_apply_deny() {
  cat src/deny_all/rules.v4 | sudo iptables-restore
  cat src/deny_all/rules.v6 | sudo ip6tables-restore
}

cmd_install_deny() {
  cmd_software
  cp -v src/deny_all/* /etc/iptables
}

cmd_port4_open() {
  hexblade_port_open="${1?'port to open'}"
  sudo iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport "$hexblade_port_open" -m state --state NEW,ESTABLISHED -j ACCEPT
  sudo iptables -A OUTPUT -p tcp -d 0.0.0.0/0 --sport "$hexblade_port_open" -m state --state ESTABLISHED -j ACCEPT
}

cmd_apply4() {
  # Set default chain policies
  sudo iptables -P INPUT DROP
  sudo iptables -P FORWARD DROP
  sudo iptables -P OUTPUT ACCEPT

  # Accept on localhost
  sudo iptables -A INPUT -i lo -j ACCEPT
  sudo iptables -A OUTPUT -o lo -j ACCEPT

  # Accept some ports
  #cmd_port_open 22

  # Allow established sessions to receive traffic
  sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
}

cmd_save() {
  sudo netfilter-persistent save
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

