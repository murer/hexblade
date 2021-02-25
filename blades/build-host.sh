#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_install() {
    ../packages/openbox/install-openbox.sh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
