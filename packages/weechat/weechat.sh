#!/bin/bash -xe

cmd_install() {
    apt -y install --no-install-recommends weechat
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"


