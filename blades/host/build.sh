#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_deps() {
    ../../packages/virtualbox/install-virtualbox.sh
    ../../packages/openbox/install-openbox.sh
}

cmd_config() {
    cp -Rv etc/* /etc
}

cmd_install() {
    cmd_deps
    cmd_config
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
