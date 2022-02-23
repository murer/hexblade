#!/bin/bash -xe

function cmd_install_server() {
  apt install -y openssh-server
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
