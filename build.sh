#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_clean() {
  sudo -E rm -rf target || true
  sudo -E rm -rf /mnt/hexblade || true
}

cmd_prepare() {
  sudo apt -y update
  sudo -E cmds/installer-prepare.sh
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

cmd_config() {
  cmds/config.sh all
}

cmd_build_live_init() {
  rm -rf target/iso
  mkdir -p target/iso
  sudo -E cmds/strap.sh
  sudo -E cmds/chroot-install.sh
  sudo -E cmds/chroot-package.sh tools
  sudo -E cmds/chroot-live.sh
}

cmd_build_live_text() {
  [[ -f "/mnt/hexblade/installer/etc/apt/sources.list" ]] || cmd_build_live_init
  sudo -E cmds/chroot-live-vbox-dkms.sh
  sudo -E cmds/mksquashfs.sh
  sudo -E cmds/iso.sh

  cp /mnt/hexblade/iso/hexblade.iso target/iso/hexblade-text.iso
  file target/iso/hexblade-text.iso
  du -hs target/iso/hexblade-text.iso
}

cmd_build_live_standard() {
  [[ -f "/mnt/hexblade/installer/etc/apt/sources.list" ]] || cmd_build_live_init
  sudo -E cmds/chroot-package.sh standard
  sudo -E cmds/chroot-package.sh ubiquity
  sudo -E cmds/chroot-live-vbox-x11.sh
  sudo -E cmds/chroot-live-vbox-dkms.sh
  sudo -E cmds/mksquashfs.sh
  sudo -E cmds/iso.sh

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
  cmd_build_live_standard
  cmd_build_checksum
}

cmd_github_release_edge() {
  gh release delete edge -y || true
  gh release create edge -t Edge -n Edge -p
  gh release upload edge target/iso/SHA256 --clobber
}

cmd_github_release_tag() {
  gh release delete edge -y || true
  gh release create edge -t Edge -n Edge -p
  gh release upload edge target/iso/SHA256 --clobber
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
