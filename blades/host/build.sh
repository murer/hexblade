#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_deps() {
    ../../packages/standard/install-standard.sh
    ../../packages/virtualbox/install-virtualbox.sh
}

cmd_config() {
    cp -Rv etc/* /etc
}

cmd_install() {
    cmd_deps
    cmd_config
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
