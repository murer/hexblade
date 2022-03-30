#!/bin/bash -xe

function cmd_install() {
  if [[ "x0" == "x$UID" ]]; then
    [[ "x-f" == "x$1" ]]
  fi
  curl -s "https://get.sdkman.io" | bash
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
