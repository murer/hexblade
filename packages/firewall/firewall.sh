#!/bin/bash -xe

cmd_install() {
  apt install -y iptables-persistent
  cmd_clean
  cmd_apply
  cmd_save
}

cmd_clean() {
  echo "
    *filter
    :INPUT ACCEPT
    :FORWARD ACCEPT
    :OUTPUT ACCEPT
    COMMIT
  " | sed 's/^\s*//g' | sudo iptables-restore
}

cmd_port_open() {
  hexblade_port_open="${1?'port to open'}"
  sudo iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport "$hexblade_port_open" -m state --state NEW,ESTABLISHED -j ACCEPT
  sudo iptables -A OUTPUT -p tcp -d 0.0.0.0/0 --sport "$hexblade_port_open" -m state --state ESTABLISHED -j ACCEPT
}

cmd_apply() {
  # Set default chain policies
  sudo iptables -P INPUT DROP
  sudo iptables -P FORWARD DROP
  sudo iptables -P OUTPUT ACCEPT

  # Accept on localhost
  sudo iptables -A INPUT -i lo -j ACCEPT
  sudo iptables -A OUTPUT -o lo -j ACCEPT

  # Accept some ports
  cmd_port_open 22

  # Allow established sessions to receive traffic
  sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
}

cmd_save() {
  sudo iptables-save | tee /etc/iptables/rules.v4 /etc/iptables/rules.v6
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

