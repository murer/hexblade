#!/bin/bash -xe

function _rsync() {
  local hex_user="$1"
  mkdir -p /mnt/hexblade/system/installer/hexblade
  rsync -av --delete --exclude .git ../../ /mnt/hexblade/system/installer/hexblade/
  if [[ "x$hex_user" != "x" ]]; then
    arch-chroot /mnt/hexblade/system chown -R "$HEX_TARGET_USER:$HEX_TARGET_USER" /installer/hexblade
  fi
}

function cmd_cleanup() {
  rm -rf /mnt/hexblade/system/installer/
}

function cmd_uchr() {
  local hex_user="${1?'user is required'}"
  shift
  _rsync
  arch-chroot -u "$hex_user" /mnt/hexblade/system "$@"
  cmd_cleanup
}

function cmd_chr() {
  _rsync
  arch-chroot /mnt/hexblade/system "$@"
  cmd_cleanup
}

function cmd_umount() {
  umount -R /mnt/hexblade/system
  rmdir /mnt/hexblade/system
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

