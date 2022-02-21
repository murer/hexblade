#!/bin/bash -xe

function cmd_test() {
  ../../../src/pack/util/tools.sh install
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
