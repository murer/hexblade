#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_clean() {
  sudo -E rm -rf /mnt/hexblade/iso || true
  sudo -E rm -rf /mnt/hexblade/image || true
  rm -rf target/iso || true
}

cmd_prepare() {
  sudo -E src/pack/util/tools.sh install
}

cmd_build() {
  sudo -E src/recipe/util/live.sh from_scratch
}

cmd_dist() {
  mkdir -p target/iso
  cp /mnt/hexblade/iso/hexblade.iso target/iso/hexblade.iso
  du -hs target/iso/hexblade.iso

  cd target/iso
  date > hexblade.released.txt
  sha256sum -b * > hexblade.SHA256
  file *
  cat SHA256
  du -hs *
  cd -
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
