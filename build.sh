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

cmd_github_release() {
  curl -f \
    -H 'Expect: ' -H "Authorization: token ebcdabd57a36045e7022cd017e67dc8d96154884" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/murer/hexblade/releases/tags/test1

  curl -f \
    -H 'Expect: ' -H "Authorization: token ebcdabd57a36045e7022cd017e67dc8d96154884" \
    -X DELETE \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/murer/hexblade/releases/test1


  curl -f \
    -H 'Expect: ' -H "Authorization: token ebcdabd57a36045e7022cd017e67dc8d96154884" \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/murer/hexblade/releases \
    -d '{"tag_name":"test1","prelease":true}'
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
