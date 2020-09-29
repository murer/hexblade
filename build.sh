#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"
export HEXBLADE_APT_ARGS='-o Dpkg::Progress-Fancy="0"'

cmd_clean() {
  rm -rf target || true
  sudo rm -rf /mnt/hexblade || true
}

cmd_prepare() {
  sudo cmds/installer-prepare.sh
}

cmd_config() {
  cmds/config.sh all
}

cmd_build_live_basic() {
  sudo cmds/strap.sh
  sudo cmds/chroot-install.sh
  #sudo cmds/chroot-package.sh basic
  sudo cmds/chroot-live.sh
  sudo cmds/mksquashfs.sh
  sudo cmds/iso.sh

  rm -rf target/iso || true
  cp -R /mnt/hexblade/iso target
  file target/iso/*
  du -hs target/iso/*

  cd target/iso
  date > released.txt
  sha256sum -b * > SHA256
  cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
