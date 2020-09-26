#!/bin/bash -xe

cmd_before_install() {
  sudo cmds/installer-prepare.sh
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
