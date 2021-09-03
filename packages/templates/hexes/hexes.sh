#!/bin/bash -xe

cmd_install() {
  #../standard/standard.sh install

  #../../virtualbox/virtualbox.sh install
  #../../docker/docker.sh install

  #../../sound/sound.sh tcp
  #../../lxdm/lxdm.sh tcplisten enable
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
