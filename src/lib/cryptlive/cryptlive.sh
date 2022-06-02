#!/bin/bash -xe

# https://github.com/mvallim/live-custom-ubuntu-from-scratch

function cmd_install() {
  pwd
  rsync -av resources/initramfs-tools/ /mnt/hexblade/system/usr/share/initramfs-tools/
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"