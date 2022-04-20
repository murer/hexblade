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
  rm -rf target/iso || true
  mkdir -p target/iso
  cp /mnt/hexblade/iso/hexblade.iso target/iso/hexblade.iso
  du -hs target/iso/hexblade.iso

  cd target/iso
  date > hexblade.released.txt
  sha256sum -b * > hexblade.SHA256
  file *
  cat hexblade.SHA256
  du -hs *
  cd -
}

cmd_download() {
  local hex_version="${1?'version, sample: edge'}"
  mkdir -p target/iso
  cd target/iso
  wget --progress=dot -e dotbytes=4M -O hexblade.iso -c \
    "https://github.com/murer/hexblade/releases/download/$hex_version/hexblade.iso"
  wget --progress=dot -e dotbytes=8K -O hexblade.SHA256 -c \
    "https://github.com/murer/hexblade/releases/download/$hex_version/hexblade.SHA256"
  wget --progress=dot -e dotbytes=8K -O hexblade.released.txt -c \
    "https://github.com/murer/hexblade/releases/download/$hex_version/hexblade.released.txt"
  sha256sum -c hexblade.SHA256
  cd -
  sudo mkdir -p /mnt/hexblade/iso
  sudo cp target/iso/hexblade.iso /mnt/hexblade/iso/hexblade.iso
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
