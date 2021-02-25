#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_install() {
    ../../packages/virtualbox/install-virtualbox.sh
    ../../packages/openbox/install-openbox.sh

    cp -Rv etc/* /etc
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
