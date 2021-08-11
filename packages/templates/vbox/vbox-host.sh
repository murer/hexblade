#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_install() {
    ../../sound/sound.sh tcp
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

