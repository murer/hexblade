#!/bin/bash -xe

function cmd_install() {
  apt -y install lxterminal
  if [[ ! -f /usr/share/lxterminal/lxterminal.conf.bak ]]; then
    cp /usr/share/lxterminal/lxterminal.conf /usr/share/lxterminal/lxterminal.conf.bak
  fi
  cp config/lxterminal.conf /usr/share/lxterminal/lxterminal.conf
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"