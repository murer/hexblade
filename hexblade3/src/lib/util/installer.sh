#!/bin/bash -xe

function cmd_config_check() {
  HEX_TARGET_USER="${HEX_TARGET_USER:-hex}"
}

function cmd_rsync() {
  mkdir -p /mnt/hexblade/system/installer/hexblade
  rsync -av --delete --exclude .git ../../ /mnt/hexblade/system/installer/hexblade/
  arch-chroot /mnt/hexblade/system chown -R "$HEX_TARGET_USER:$HEX_TARGET_USER" /installer/hexblade
}

function cmd_uchr() {
  cmd_rsync
  arch-chroot -u "$HEX_TARGET_USER" /mnt/hexblade/system "$@"
}

function cmd_chr() {
  cmd_rsync
  arch-chroot /mnt/hexblade/system "$@"
}

cmd_config_check

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

