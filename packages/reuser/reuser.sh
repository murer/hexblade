#!/bin/bash -xe

cmd_install() {
  cp src/reuser.sh /usr/local/bin/reuser.sh
  chmod +x /usr/local/bin/reuser.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
