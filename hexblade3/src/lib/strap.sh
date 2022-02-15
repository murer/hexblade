#!/bin/bash -e

function cmd_strap() {
  hexblade_apt_mirror="${1}"
  
  tmp_strap_mirror=""
  [[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://${hexblade_apt_mirror}.archive.ubuntu.com/ubuntu/"

  sudo debootstrap focal /mnt/hexblade/system "$tmp_strap_mirror"
}


set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"