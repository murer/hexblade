#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"
export HEXBLADE_APT_ARGS='-o Dpkg::Progress-Fancy="0"'

cmd_before_install() {
  sudo cmds/installer-prepare.sh
}

cmd_config_params() {
  echo "us"
  echo "n"
  echo ""
  echo ""
  echo "hexblade"
  echo "ubuntu"
  echo "hexblade"
  echo "hexblade"
}

cmd_script() {
  ./build.sh clean
  cmd_config_params | cmds/config.sh all
  #./build.sh build_live_text
  ./build.sh build_live_basic
  ./build.sh build_checksum
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
