#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"
export HEXBLADE_APT_ARGS='-o Dpkg::Progress-Fancy="0"'

cmd_before_install() {
  sudo cmds/installer-prepare.sh
}

cmd_config_params() {
  echo "n"
  echo ""
  echo ""
  echo "hexblade"
  echo "ubuntu"
  echo "hexblade"
  echo "hexblade"
}

cmd_script() {
  sudo cmds/strap.sh
  cmd_config_params | cmds/config.sh all
  sudo cmds/chroot-install.sh
  sudo cmds/chroot-packages.sh
  sudo cmds/chroot-live.sh
  sudo cmds/mksquashfs.sh
  sudo cmds/iso.sh
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
