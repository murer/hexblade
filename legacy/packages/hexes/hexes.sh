#!/bin/bash -xe

cmd_install() {
  cp src/hexes-*.sh /usr/local/bin
  chmod +x /usr/local/bin/hexes-*.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
