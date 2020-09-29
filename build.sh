#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"
#export HEXBLADE_APT_ARGS='-o Dpkg::Progress-Fancy="0"'

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

cmd_build_live_init() {
  rm -rf target/iso
  mkdir -p target/iso
  sudo cmds/strap.sh
  sudo cmds/chroot-install.sh
}

cmd_build_live_text() {
  [[ -f "/mnt/hexblade/installer/etc/apt/sources.list" ]] || cmd_build_live_init
  sudo cmds/chroot-live.sh
  sudo cmds/mksquashfs.sh
  sudo cmds/iso.sh

  cp /mnt/hexblade/iso/hexblade.iso target/iso/hexblade-text.iso
  file target/iso/hexblade-text.iso
  du -hs target/iso/hexblade-text.iso
}

cmd_build_live_basic() {
  [[ -f "/mnt/hexblade/installer/etc/apt/sources.list" ]] || cmd_build_live_init
  sudo cmds/chroot-package.sh basic
  sudo cmds/chroot-package.sh ubiquity
  sudo cmds/mksquashfs.sh
  sudo cmds/iso.sh

  cp /mnt/hexblade/iso/hexblade.iso target/iso/hexblade.iso
  file target/iso/hexblade.iso
  du -hs target/iso/hexblade.iso
}

cmd_build_checksum() {
  cd target/iso
  date > released.txt
  sha256sum -b * > SHA256
  file *
  cat SHA256
  du -hs *
  cd -
}

cmd_build_live() {
  cmd_build_live_text
  cmd_build_live_basic
  cmd_build_checksum
}

cmd_build_docker() {
  docker build -t hexblade/hexblade:dev .
}


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
