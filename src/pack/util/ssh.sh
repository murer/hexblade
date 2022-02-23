#!/bin/bash -xe

function cmd_install_server() {
  apt install -y openssh-server
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"