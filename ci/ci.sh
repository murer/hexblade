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
  # sudo rm -rf /mnt/hexblade || true
  # sudo mkdir -p  /mnt/hexblade/installer
  # sudo cmds/strap.sh
  # cmd_config_params | cmds/config.sh all
  # sudo cmds/chroot-install.sh
  # sudo cmds/chroot-package.sh basic
  # sudo cmds/chroot-live.sh
  # sudo cmds/mksquashfs.sh
  # sudo cmds/iso.sh
  #
  # rm -rf target/iso || true
  # cp -R /mnt/hexblade/iso target
  # file target/iso/*
  # du -hs target/iso/*

  ./build.sh build_live_basic
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
